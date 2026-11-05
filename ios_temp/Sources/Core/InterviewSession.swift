nonisolated struct InterviewSession: Sendable {
    let configuration: InterviewConfiguration
    private(set) var phase: InterviewPhase = .ready
    private(set) var activeOperation: InterviewOperationID?
    private(set) var turns: [InterviewTurn] = []
    private(set) var movement: MovementScoring
    private(set) var termination: InterviewTerminationReason?
    private(set) var result: InterviewScores?
    private(set) var exitConfirmationPause: ExitConfirmationPause?
    private(set) var observationOperation = InterviewOperationID(rawValue: 0)

    private var nextOperationValue = 0
    private var nextQuestionNumber = 1
    private var pendingQuestion: String?
    private var recognitionIsContinuation = false
    private var recognitionIsRetry = false
    private var waitingSince: Duration?
    private var silenceSince: Duration?
    private var lastTime: Duration = .zero
    private var evaluatedQuestions: [QuestionScores]?
    private var totalPausedTime: Duration = .zero

    init(configuration: InterviewConfiguration, movementExclusions: Set<MovementExclusionReason>) {
        self.configuration = configuration
        self.movement = MovementScoring(exclusions: movementExclusions)
    }

    var completedTurns: [InterviewTurn] { turns.filter(\.isCompleted) }
    var completedQuestionCount: Int { completedTurns.count }

    var isMovementScoringInterval: Bool {
        phase != .ready && phase != .resultsDisplayed && exitConfirmationPause == nil
    }

    func silenceCountdownRemaining(at time: Duration) -> Duration? {
        let current = interviewTime(at: time)
        guard phase == .answering, let silenceSince, current >= silenceSince else { return nil }
        return max(.zero, .seconds(3) - (current - silenceSince))
    }

    // 실제 장치·타이머 대신 호출자가 시간순 사건을 제공한다. 동시 사건의 우선순위는 정하지 않는다.
    @discardableResult
    mutating func handle(_ event: InterviewEvent, at time: Duration) throws -> [InterviewCommand] {
        var updated = self
        let commands = try updated.process(event, at: time)
        self = updated
        return commands
    }

    private mutating func process(_ event: InterviewEvent, at time: Duration) throws -> [InterviewCommand] {
        guard time >= .zero, time >= lastTime else { throw InterviewSessionError.invalidTime }
        lastTime = time
        if let pause = exitConfirmationPause {
            if case .exitConfirmationCancelled(let confirmation) = event,
               confirmation == pause.confirmation {
                return try resumeAfterExitCancellation(at: time, pause: pause)
            }
            return []
        }
        let current = interviewTime(at: time)
        let wasExcluded = !movement.exclusions.isEmpty
        if isMovementScoringInterval { try movement.advanceTime(to: current) }
        var commands: [InterviewCommand] = []
        if !wasExcluded, !movement.exclusions.isEmpty {
            commands.append(.notifyMovementExcluded(movement.exclusions))
        }
        if case .exitConfirmationPresented = event {
            guard phase != .ready, phase != .resultsDisplayed else {
                throw InterviewSessionError.invalidTransition
            }
            if let remaining = responseTimerRemaining(at: current), remaining <= .zero {
                throw InterviewSessionError.approvalRequired(.exitConfirmationAtResponseDeadline)
            }
            let confirmation = ExitConfirmationID(rawValue: try allocateOperationValue())
            exitConfirmationPause = ExitConfirmationPause(
                confirmation: confirmation, phase: phase, wallTime: time, interviewTime: current
            )
            commands.append(.suspendInterviewWork(
                confirmation: confirmation, phase: phase, operation: activeOperation,
                observation: observationOperation
            ))
            return commands
        }
        commands += try transition(event, at: current)
        return commands
    }

    private mutating func transition(_ event: InterviewEvent, at time: Duration) throws -> [InterviewCommand] {
        switch event {
        case .start:
            guard phase == .ready else { throw InterviewSessionError.invalidTransition }
            observationOperation = InterviewOperationID(rawValue: try allocateOperationValue())
            return [try prepareQuestion(number: 1)]

        case .questionPrepared(let operation, let text):
            guard activeOperation == operation, phase == .preparingQuestion else { return [] }
            pendingQuestion = text
            let playback = try newOperation()
            phase = .playingQuestion
            return [.playQuestion(operation: playback, number: nextQuestionNumber, text: text)]

        case .repeatPromptPrepared(let operation, let text):
            guard activeOperation == operation, phase == .preparingRepeatPrompt else { return [] }
            let playback = try newOperation()
            phase = .playingRepeatPrompt
            return [.playRepeatPrompt(operation: playback, text: text)]

        case .playbackFinished(let operation):
            guard activeOperation == operation else { return [] }
            if phase == .playingQuestion {
                guard let pendingQuestion else { throw InterviewSessionError.invalidTransition }
                turns.append(InterviewTurn(questionNumber: nextQuestionNumber, question: pendingQuestion))
                self.pendingQuestion = nil
                recognitionIsContinuation = false
                recognitionIsRetry = false
                return [try beginRecognition()]
            }
            if phase == .playingRepeatPrompt { return [try beginRecognition()] }
            return []

        case .recognitionStarted(let operation):
            guard activeOperation == operation, phase == .startingRecognition else { return [] }
            phase = .waitingForSpeech
            waitingSince = time
            return []

        case .newSpeechSegment(let operation, let text):
            guard activeOperation == operation, phase == .waitingForSpeech || phase == .answering else { return [] }
            guard text.contains(where: { !$0.isWhitespace }) else { throw InterviewSessionError.invalidSpeechSegment }
            phase = .answering
            waitingSince = nil
            turns[turns.count - 1].answerSegments.append(text)
            return []

        case .speechActivity(let operation):
            guard activeOperation == operation, phase == .answering else { return [] }
            silenceSince = nil
            return []

        case .silenceBegan(let operation):
            guard activeOperation == operation, phase == .answering else { return [] }
            if silenceSince == nil { silenceSince = time }
            return []

        case .timeAdvanced:
            if phase == .waitingForSpeech, let waitingSince, time - waitingSince >= .seconds(7) {
                return try handleNonresponse()
            }
            if phase == .answering, let silenceSince, time - silenceSince >= .seconds(3) {
                return try completeAnswer()
            }
            return []

        case .continueSpeaking:
            return try continueAnswer()

        case .evaluationFinished(let operation, let questions):
            guard activeOperation == operation, phase == .evaluating else { return [] }
            let numbers = Set(completedTurns.map(\.questionNumber))
            guard questions.count == numbers.count, Set(questions.map(\.questionNumber)) == numbers else {
                throw InterviewSessionError.invalidEvaluation
            }
            evaluatedQuestions = questions
            activeOperation = nil
            phase = .resultsReady
            return [.resultsAvailable]

        case .resultsWillDisplay:
            guard phase == .resultsReady, let evaluatedQuestions, let termination else {
                throw InterviewSessionError.invalidTransition
            }
            let movementScores: MovementCategoryScores?
            do { movementScores = try movement.scoresForOverall() }
            catch MovementScoringError.observationsRequired {
                throw InterviewSessionError.approvalRequired(.movementWithoutObservations)
            }
            let scores = try OverallScoring.calculate(
                configuration: configuration, completedQuestions: evaluatedQuestions,
                movement: movementScores, termination: termination
            )
            result = scores
            phase = .resultsDisplayed
            return [.presentResults(scores)]

        case .movementCheck(let operation, let gaze, let head):
            if operation == observationOperation, isMovementScoringInterval {
                movement.recordCheck(gaze: gaze, head: head)
            }
            return []

        case .trackingAvailability(let operation, let gaze, let head):
            if operation == observationOperation, isMovementScoringInterval {
                try movement.updateAvailability(gaze: gaze, head: head, at: time)
            }
            return []

        case .exitConfirmationPresented, .exitConfirmationCancelled:
            return []
        }
    }

    private func interviewTime(at wallTime: Duration) -> Duration {
        exitConfirmationPause?.interviewTime ?? wallTime - totalPausedTime
    }

    private mutating func resumeAfterExitCancellation(at time: Duration, pause: ExitConfirmationPause) throws -> [InterviewCommand] {
        if let remaining = responseTimerRemaining(at: pause.interviewTime), remaining < .seconds(1) {
            if phase == .waitingForSpeech, let waitingSince { self.waitingSince = waitingSince + .seconds(1) }
            if phase == .answering, let silenceSince { self.silenceSince = silenceSince + .seconds(1) }
        }
        totalPausedTime += time - pause.wallTime
        exitConfirmationPause = nil
        let previousOperation = activeOperation
        if previousOperation != nil { _ = try newOperation() }
        observationOperation = InterviewOperationID(rawValue: try allocateOperationValue())
        return [.resumeInterviewWork(
            confirmation: pause.confirmation, phase: phase, previousOperation: previousOperation,
            operation: activeOperation, observation: observationOperation
        )]
    }

    private func responseTimerRemaining(at time: Duration) -> Duration? {
        if phase == .waitingForSpeech, let waitingSince { return .seconds(7) - (time - waitingSince) }
        if phase == .answering, let silenceSince { return .seconds(3) - (time - silenceSince) }
        return nil
    }

    private mutating func allocateOperationValue() throws -> Int {
        let next = nextOperationValue.addingReportingOverflow(1)
        guard !next.overflow else { throw InterviewSessionError.operationLimit }
        nextOperationValue = next.partialValue
        return nextOperationValue
    }

    private mutating func newOperation() throws -> InterviewOperationID {
        let operation = InterviewOperationID(rawValue: try allocateOperationValue())
        activeOperation = operation
        return operation
    }

    private mutating func prepareQuestion(number: Int) throws -> InterviewCommand {
        let operation = try newOperation()
        nextQuestionNumber = number
        phase = .preparingQuestion
        return .prepareQuestion(operation: operation, number: number, completedAnswers: completedTurns)
    }

    private mutating func beginRecognition() throws -> InterviewCommand {
        guard let turn = turns.last else { throw InterviewSessionError.invalidTransition }
        let operation = try newOperation()
        phase = .startingRecognition
        waitingSince = nil
        silenceSince = nil
        return .startRecognition(operation: operation, number: turn.questionNumber, isContinuation: recognitionIsContinuation)
    }

    private mutating func completeAnswer() throws -> [InterviewCommand] {
        guard let operation = activeOperation, let turn = turns.last else { throw InterviewSessionError.invalidTransition }
        turns[turns.count - 1].isCompleted = true
        waitingSince = nil
        silenceSince = nil
        let stop = InterviewCommand.stopRecognition(operation: operation)
        if turn.questionNumber < configuration.questionCount {
            return [stop, try prepareQuestion(number: turn.questionNumber + 1)]
        }
        termination = .completed
        return [stop, try beginEvaluation()]
    }

    private mutating func handleNonresponse() throws -> [InterviewCommand] {
        guard let operation = activeOperation, let turn = turns.last else { throw InterviewSessionError.invalidTransition }
        let stop = InterviewCommand.stopRecognition(operation: operation)
        waitingSince = nil
        if !recognitionIsRetry {
            recognitionIsRetry = true
            let repeatOperation = try newOperation()
            phase = .preparingRepeatPrompt
            return [stop, .prepareRepeatPrompt(operation: repeatOperation, number: turn.questionNumber, originalQuestion: turn.question)]
        }
        termination = recognitionIsContinuation ? .failedContinuation : .newQuestionNonresponse
        return [stop, try beginEvaluation()]
    }

    private mutating func continueAnswer() throws -> [InterviewCommand] {
        guard [.preparingQuestion, .playingQuestion, .evaluating].contains(phase) else {
            throw InterviewSessionError.approvalRequired(.continuationInPhase(phase))
        }
        if phase == .evaluating, termination != .completed {
            throw InterviewSessionError.approvalRequired(.continuationAfterNonresponse)
        }
        guard let operation = activeOperation, turns.last?.isCompleted == true else {
            throw InterviewSessionError.invalidTransition
        }
        let cancel: InterviewCommand
        switch phase {
        case .preparingQuestion: cancel = .cancelQuestionPreparation(operation: operation)
        case .playingQuestion: cancel = .stopPlayback(operation: operation)
        case .evaluating: cancel = .cancelEvaluation(operation: operation)
        default: throw InterviewSessionError.invalidTransition
        }
        pendingQuestion = nil
        termination = nil
        evaluatedQuestions = nil
        recognitionIsContinuation = true
        recognitionIsRetry = false
        return [cancel, try beginRecognition()]
    }

    private mutating func beginEvaluation() throws -> InterviewCommand {
        guard let termination else { throw InterviewSessionError.invalidTransition }
        let operation = try newOperation()
        phase = .evaluating
        return .evaluateAnswers(operation: operation, completedAnswers: completedTurns, reason: termination)
    }
}
