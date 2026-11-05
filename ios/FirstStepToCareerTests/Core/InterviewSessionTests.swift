import Testing
@testable import FirstStepToCareer

struct InterviewSessionTests {
    @Test(arguments: [3, 4, 5, 6, 7])
    func completeInterviewUsesConfiguredCountAndScoresEachAnswerOnce(count: Int) throws {
        var session = try makeSession(count: count)
        try session.handle(.start, at: .zero)
        var time = Duration.zero
        for number in 1...count {
            try beginQuestion(&session, at: time, text: "質問\(number)")
            time = try finishAnswer(&session, at: time + .seconds(1), text: "回答\(number)")
            #expect(session.completedQuestionCount == number)
        }
        #expect(session.phase == .evaluating)
        #expect(session.termination == .completed)
        let evaluation = try operation(session)
        let questions = try scores(session, value: 75)
        try session.handle(.evaluationFinished(operation: evaluation, questions: questions), at: time)
        #expect(session.phase == .resultsReady)
        try session.handle(.resultsWillDisplay, at: time + .seconds(1))
        #expect(session.phase == .resultsDisplayed)
        #expect(session.result?.overall.formatted == "75.0")
        #expect(session.isEligibleForHistory)
        #expect(session.outcome == .completed(try #require(session.result)))
        #expect(session.turns.map(\.questionNumber) == Array(1...count))
        #expect(session.turns.last?.answerSegments == ["回答\(count)"])
    }

    @Test func silenceWaitsForNewWordsAndRecognitionAcknowledgement() throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        try session.handle(.questionPrepared(operation: operation(session), text: "質問"), at: .zero)
        try session.handle(.playbackFinished(operation: operation(session)), at: .zero)
        let recognition = try operation(session)
        try session.handle(.timeAdvanced, at: .seconds(20))
        #expect(session.phase == .startingRecognition)
        try session.handle(.recognitionStarted(operation: recognition), at: .seconds(20))
        try session.handle(.silenceBegan(operation: recognition), at: .seconds(20))
        try session.handle(.timeAdvanced, at: .seconds(23))
        #expect(session.phase == .waitingForSpeech)
        #expect(session.completedQuestionCount == 0)
        try session.handle(.newSpeechSegment(operation: recognition, text: "回答"), at: .seconds(24))
        try session.handle(.silenceBegan(operation: recognition), at: .seconds(24))
        #expect(session.silenceCountdownRemaining(at: .seconds(25)) == .seconds(2))
        try session.handle(.timeAdvanced, at: .milliseconds(26999))
        #expect(session.phase == .answering)
        try session.handle(.timeAdvanced, at: .seconds(27))
        #expect(session.completedQuestionCount == 1)
    }

    @Test func speechActivityRestartsContinuousSilenceCountdown() throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        try beginQuestion(&session, at: .zero)
        let recognition = try operation(session)
        try session.handle(.newSpeechSegment(operation: recognition, text: "回答"), at: .zero)
        try session.handle(.silenceBegan(operation: recognition), at: .zero)
        try session.handle(.silenceBegan(operation: recognition), at: .seconds(1))
        #expect(session.silenceCountdownRemaining(at: .seconds(2)) == .seconds(1))
        try session.handle(.speechActivity(operation: recognition), at: .seconds(2))
        #expect(session.silenceCountdownRemaining(at: .seconds(2)) == nil)
        try session.handle(.silenceBegan(operation: recognition), at: .seconds(3))
        try session.handle(.timeAdvanced, at: .milliseconds(5999))
        #expect(session.completedQuestionCount == 0)
        try session.handle(.timeAdvanced, at: .seconds(6))
        #expect(session.completedQuestionCount == 1)
    }

    @Test func nonresponseWaitsSevenSecondsTwiceExcludingRepeatPlayback() throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        try beginQuestion(&session, at: .zero)
        try session.handle(.timeAdvanced, at: .milliseconds(6999))
        #expect(session.phase == .waitingForSpeech)
        let commands = try session.handle(.timeAdvanced, at: .seconds(7))
        #expect(session.phase == .preparingRepeatPrompt)
        #expect(commands.count == 2)
        try session.handle(.timeAdvanced, at: .seconds(30))
        #expect(session.phase == .preparingRepeatPrompt)
        try beginRepeat(&session, at: .seconds(30))
        try session.handle(.timeAdvanced, at: .milliseconds(36999))
        #expect(session.phase == .waitingForSpeech)
        let recognition = try operation(session)
        let ended = try session.handle(.timeAdvanced, at: .seconds(37))
        #expect(session.termination == .newQuestionNonresponse)
        #expect(session.completedQuestionCount == 0)
        #expect(session.phase == .endedWithoutScore)
        #expect(ended == [.stopRecognition(operation: recognition), .endWithoutScore(
            reason: .newQuestionNonresponse, operation: recognition, observation: session.observationOperation
        )])
        #expect(session.outcome == .endedWithoutScore(.newQuestionNonresponse))
        #expect(session.result == nil)
        #expect(!session.isEligibleForHistory)
        #expect(try session.handle(.evaluationFinished(operation: recognition, questions: []), at: .seconds(37)).isEmpty)
        #expect(try session.handle(.resultsWillDisplay, at: .seconds(37)).isEmpty)
        #expect(session.result == nil)
    }

    @Test(arguments: [false, true])
    func continuationCancelsPreparationOrPlaybackAndReusesQuestionNumber(duringPlayback: Bool) throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        try beginQuestion(&session, at: .zero, text: "最初の質問")
        let time = try finishAnswer(&session, at: .zero, text: "元の回答")
        let canceledPreparation = try operation(session)
        if duringPlayback {
            try session.handle(.questionPrepared(operation: canceledPreparation, text: "中断される質問"), at: time)
        }
        let canceled = try operation(session)
        let commands = try session.handle(.continueSpeaking, at: time)
        let expectedCancel: InterviewCommand = duringPlayback ? .stopPlayback(operation: canceled) : .cancelQuestionPreparation(operation: canceled)
        #expect(commands.first == expectedCancel)
        let recognition = try operation(session)
        try session.handle(.recognitionStarted(operation: recognition), at: time)
        try session.handle(.questionPrepared(operation: canceledPreparation, text: "遅れた質問"), at: time)
        try session.handle(.playbackFinished(operation: canceled), at: time)
        #expect(session.phase == .waitingForSpeech)
        #expect(session.completedQuestionCount == 1)
        #expect(session.turns.count == 1)
        #expect(session.turns[0].answerSegments == ["元の回答"])
        let nextTime = try finishAnswer(&session, at: time + .seconds(1), text: "追加の回答")
        #expect(session.completedQuestionCount == 1)
        #expect(session.turns[0].answerSegments == ["元の回答", "追加の回答"])
        let next = try operation(session)
        let playback = try session.handle(.questionPrepared(operation: next, text: "再検討した質問"), at: nextTime)
        #expect(playback == [.playQuestion(operation: try operation(session), number: 2, text: "再検討した質問")])
        try session.handle(.playbackFinished(operation: operation(session)), at: nextTime)
        #expect(session.turns.map(\.question) == ["最初の質問", "再検討した質問"])
    }

    @Test func continuationRequiresNewWordsAndRetainsCreditOnFailure() throws {
        var session = try makeSession(count: 5)
        try session.handle(.start, at: .zero)
        try beginQuestion(&session, at: .zero)
        let time = try finishAnswer(&session, at: .zero, text: "既存の回答")
        try session.handle(.continueSpeaking, at: time)
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
        try session.handle(.silenceBegan(operation: operation(session)), at: time)
        try session.handle(.timeAdvanced, at: time + .seconds(7))
        #expect(session.phase == .preparingRepeatPrompt)
        try beginRepeat(&session, at: time + .seconds(8))
        try session.handle(.timeAdvanced, at: time + .seconds(15))
        #expect(session.termination == .failedContinuation)
        #expect(session.completedQuestionCount == 1)
        #expect(session.turns[0].answerSegments == ["既存の回答"])
        #expect(session.phase == .endedWithoutScore)
        #expect(session.outcome == .endedWithoutScore(.failedContinuation))
        #expect(session.result == nil)
        #expect(session.activeOperation == nil)
        #expect(!session.isEligibleForHistory)
    }

    @Test func finalEvaluationCanBeCanceledAndRerunWithTheFullAnswer() throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        var time = Duration.zero
        for _ in 1...3 {
            try beginQuestion(&session, at: time)
            time = try finishAnswer(&session, at: time, text: "回答")
        }
        let oldEvaluation = try operation(session)
        let oldScores = try scores(session, value: 50)
        let commands = try session.handle(.continueSpeaking, at: time)
        #expect(commands.first == .cancelEvaluation(operation: oldEvaluation))
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
        try session.handle(.evaluationFinished(operation: oldEvaluation, questions: oldScores), at: time)
        #expect(session.phase == .waitingForSpeech)
        time = try finishAnswer(&session, at: time, text: "追加")
        #expect(session.completedQuestionCount == 3)
        #expect(session.completedTurns.last?.answerSegments == ["回答", "追加"])
        try session.handle(.evaluationFinished(operation: operation(session), questions: scores(session, value: 75)), at: time)
        try session.handle(.resultsWillDisplay, at: time)
        #expect(session.result?.overall.formatted == "75.0")
    }

    @Test func movementCoversAllStagesUntilImmediatelyBeforeResults() throws {
        var session = try makeSession(exclusions: [])
        let outside = try ScreenPosition(x: -1, y: 0.5)
        let center = try ScreenPosition(x: 0.5, y: 0.5)
        try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: .zero)
        #expect(try session.movement.assessment == .awaitingObservations)
        try session.handle(.start, at: .zero)
        var checks = 0
        var time = Duration.zero
        for _ in 1...3 {
            try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time)
            checks += 1
            try session.handle(.questionPrepared(operation: operation(session), text: "質問"), at: time)
            try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time)
            checks += 1
            try session.handle(.playbackFinished(operation: operation(session)), at: time)
            try session.handle(.recognitionStarted(operation: operation(session)), at: time)
            try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time)
            checks += 1
            let recognition = try operation(session)
            try session.handle(.newSpeechSegment(operation: recognition, text: "回答"), at: time)
            try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time)
            checks += 1
            try session.handle(.silenceBegan(operation: recognition), at: time)
            try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time + .seconds(1))
            checks += 1
            time += .seconds(3)
            try session.handle(.timeAdvanced, at: time)
        }
        try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time)
        checks += 1
        try session.handle(.evaluationFinished(operation: operation(session), questions: scores(session, value: 80)), at: time)
        try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: time)
        checks += 1
        try session.handle(.resultsWillDisplay, at: time)
        let expectedGaze = try Score(numerator: 1000 - checks * 4, denominator: 10)
        #expect(session.result?.movement?.gaze == expectedGaze)
        try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: outside), at: time + .seconds(1))
        #expect(session.result?.movement?.gaze == expectedGaze)
    }

    @Test func trackingFailureNotifiesOnceAndInterviewContinues() throws {
        var session = try makeSession(exclusions: [])
        try session.handle(.start, at: .zero)
        try session.handle(.movementCheck(operation: session.observationOperation, gaze: ScreenPosition(x: -1, y: 0.5), head: ScreenPosition(x: -1, y: 0.5)), at: .zero)
        try session.handle(.trackingAvailability(operation: session.observationOperation, gaze: false, head: true), at: .zero)
        let commands = try session.handle(.timeAdvanced, at: .seconds(3))
        #expect(commands == [.notifyMovementExcluded([.interviewTrackingUnavailable])])
        #expect(session.phase == .preparingQuestion)
        #expect(try session.handle(.timeAdvanced, at: .seconds(4)).isEmpty)
        #expect(try session.movement.scoresForOverall() == nil)
        try beginQuestion(&session, at: .seconds(4))
        _ = try finishAnswer(&session, at: .seconds(4), text: "回答")
        #expect(session.completedQuestionCount == 1)
    }

    @Test func undecidedBehaviorsAndInvalidInputsDoNotChangeTheSession() throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        try beginQuestion(&session, at: .zero)
        let recognition = try operation(session)
        for text in ["", " ", "\n\t"] {
            #expect(throws: InterviewSessionError.invalidSpeechSegment) {
                try session.handle(.newSpeechSegment(operation: recognition, text: text), at: .seconds(1))
            }
        }
        #expect(throws: InterviewSessionError.invalidTime) { try session.handle(.timeAdvanced, at: .seconds(-1)) }
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.newSpeechSegment(operation: recognition, text: "回答"), at: .zero)
        try session.handle(.silenceBegan(operation: recognition), at: .zero)
        #expect(throws: InterviewSessionError.approvalRequired(.continuationInPhase(.answering))) {
            try session.handle(.continueSpeaking, at: .seconds(1))
        }
        try session.handle(.timeAdvanced, at: .seconds(3))
        #expect(throws: InterviewSessionError.invalidTime) { try session.handle(.timeAdvanced, at: .seconds(2)) }
        #expect(session.completedQuestionCount == 1)
    }

    @Test func originalMultilingualTextIsPreservedWithoutJoiningPolicy() throws {
        var session = try makeSession()
        let text = "  日本語と한국어🙂\n< > '\" ; --  "
        try session.handle(.start, at: .zero)
        try beginQuestion(&session, at: .zero, text: text)
        _ = try finishAnswer(&session, at: .zero, text: text)
        #expect(session.turns[0].question == text)
        #expect(session.turns[0].answerSegments == [text])
    }

    @Test func earlyTerminationIsUnscoredEvenWithCompletedAnswers() throws {
        var session = try makeSession(count: 5)
        try session.handle(.start, at: .zero)
        var time = Duration.zero
        for _ in 1...3 {
            try beginQuestion(&session, at: time)
            time = try finishAnswer(&session, at: time, text: "回答")
        }
        try beginQuestion(&session, at: time)
        time += .seconds(7)
        try session.handle(.timeAdvanced, at: time)
        try beginRepeat(&session, at: time)
        time += .seconds(7)
        try session.handle(.timeAdvanced, at: time)
        #expect(session.termination == .newQuestionNonresponse)
        #expect(session.completedQuestionCount == 3)
        #expect(session.phase == .endedWithoutScore)
        #expect(session.outcome == .endedWithoutScore(.newQuestionNonresponse))
        #expect(!session.isEligibleForHistory)
        let evaluated = try scores(session, value: 80)
        #expect(try session.handle(.continueSpeaking, at: time).isEmpty)
        #expect(try session.handle(.evaluationFinished(operation: InterviewOperationID(rawValue: 1), questions: evaluated), at: time).isEmpty)
        #expect(try session.handle(.resultsWillDisplay, at: time).isEmpty)
        #expect(session.result == nil)
    }

    @Test(arguments: [false, true])
    func finalAnswerContinuationFailureDiscardsOldEvaluationAndStopsObservation(trackMovement: Bool) throws {
        var session = try makeSession(exclusions: trackMovement ? [] : [.settingDisabled])
        try session.handle(.start, at: .zero)
        #expect(session.outcome == nil)
        #expect(!session.isEligibleForHistory)
        var time = Duration.zero
        for _ in 1...3 {
            try beginQuestion(&session, at: time)
            time = try finishAnswer(&session, at: time, text: "回答")
        }
        let oldEvaluation = try operation(session)
        let oldGrades = try scores(session, value: 100)
        try session.handle(.continueSpeaking, at: time)
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
        time += .seconds(7)
        try session.handle(.timeAdvanced, at: time)
        try beginRepeat(&session, at: time)
        let recognition = try operation(session)
        time += .seconds(7)
        let commands = try session.handle(.timeAdvanced, at: time)
        #expect(commands == [.stopRecognition(operation: recognition), .endWithoutScore(
            reason: .failedContinuation, operation: recognition, observation: session.observationOperation
        )])
        #expect(session.completedQuestionCount == 3)
        #expect(session.outcome == .endedWithoutScore(.failedContinuation))
        #expect(!session.isEligibleForHistory)
        #expect(!session.isMovementScoringInterval)
        let movement = try session.movement.assessment
        let outside = try ScreenPosition(x: -1, y: -1)
        let lateEvents: [InterviewEvent] = [
            .evaluationFinished(operation: oldEvaluation, questions: oldGrades), .resultsWillDisplay,
            .newSpeechSegment(operation: recognition, text: "遅れた回答"), .continueSpeaking,
            .movementCheck(operation: session.observationOperation, gaze: outside, head: outside),
            .trackingAvailability(operation: session.observationOperation, gaze: false, head: false),
            .timeAdvanced, .start
        ]
        for event in lateEvents { #expect(try session.handle(event, at: time + .seconds(10)).isEmpty) }
        #expect(try session.movement.assessment == movement)
        #expect(session.result == nil)
        #expect(session.turns.last?.answerSegments == ["回答"])
        #expect(session.phase == .endedWithoutScore)
    }

    @Test func absentMovementObservationsRemainAnApprovalBoundary() throws {
        var session = try makeSession(exclusions: [])
        try session.handle(.start, at: .zero)
        var time = Duration.zero
        for _ in 1...3 {
            try beginQuestion(&session, at: time)
            time = try finishAnswer(&session, at: time, text: "回答")
        }
        try session.handle(.evaluationFinished(operation: operation(session), questions: scores(session, value: 75)), at: time)
        #expect(throws: InterviewSessionError.approvalRequired(.movementWithoutObservations)) {
            try session.handle(.resultsWillDisplay, at: time)
        }
        #expect(session.phase == .resultsReady)
        #expect(session.result == nil)
    }

    @Test func gradesMustMatchTheCompletedQuestions() throws {
        var session = try makeSession()
        try session.handle(.start, at: .zero)
        var time = Duration.zero
        for _ in 1...3 {
            try beginQuestion(&session, at: time)
            time = try finishAnswer(&session, at: time, text: "回答")
        }
        let evaluation = try operation(session)
        #expect(throws: InterviewSessionError.invalidEvaluation) {
            try session.handle(.evaluationFinished(operation: evaluation, questions: []), at: time)
        }
        #expect(session.phase == .evaluating)
        #expect(session.activeOperation == evaluation)
    }

    private func makeSession(count: Int = 3, exclusions: Set<MovementExclusionReason> = [.settingDisabled]) throws -> InterviewSession {
        InterviewSession(configuration: try InterviewConfiguration(questionCount: count), movementExclusions: exclusions)
    }

    private func operation(_ session: InterviewSession) throws -> InterviewOperationID {
        try #require(session.activeOperation)
    }

    private func beginQuestion(_ session: inout InterviewSession, at time: Duration, text: String = "質問") throws {
        #expect(session.phase == .preparingQuestion)
        try session.handle(.questionPrepared(operation: operation(session), text: text), at: time)
        try session.handle(.playbackFinished(operation: operation(session)), at: time)
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
    }

    private func beginRepeat(_ session: inout InterviewSession, at time: Duration) throws {
        try session.handle(.repeatPromptPrepared(operation: operation(session), text: "再質問"), at: time)
        try session.handle(.playbackFinished(operation: operation(session)), at: time)
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
    }

    private func finishAnswer(_ session: inout InterviewSession, at time: Duration, text: String) throws -> Duration {
        let recognition = try operation(session)
        try session.handle(.newSpeechSegment(operation: recognition, text: text), at: time)
        try session.handle(.silenceBegan(operation: recognition), at: time)
        let end = time + .seconds(3)
        try session.handle(.timeAdvanced, at: end)
        return end
    }

    private func scores(_ session: InterviewSession, value: Int) throws -> [QuestionScores] {
        let score = try Score(numerator: value)
        return try session.completedTurns.map {
            try QuestionScores(questionNumber: $0.questionNumber, structure: score, logic: score, realism: score)
        }
    }
}
