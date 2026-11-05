import Testing
@testable import FirstStepToCareer

struct ExitConfirmationIntegrationTests {
    @Test(arguments: [
        InterviewPhase.preparingQuestion, .playingQuestion, .startingRecognition,
        .waitingForSpeech, .answering, .preparingRepeatPrompt, .playingRepeatPrompt,
        .evaluating, .resultsReady
    ])
    func everyActivePhaseSuspendsItsInputsAndResumesWithNewWorkNumbers(target: InterviewPhase) throws {
        var (session, time) = try fixture(in: target)
        let previousTurns = session.turns
        let previousTermination = session.termination
        let previousOperation = session.activeOperation
        let previousObservation = session.observationOperation
        time += .milliseconds(500)
        try session.handle(.exitConfirmationPresented, at: time)
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        let old = previousOperation ?? InterviewOperationID(rawValue: 0)
        let evaluated = try grades(session)
        let ignored: [InterviewEvent] = [
            .questionPrepared(operation: old, text: "確認中の質問"),
            .repeatPromptPrepared(operation: old, text: "確認中の再質問"),
            .playbackFinished(operation: old), .recognitionStarted(operation: old),
            .newSpeechSegment(operation: old, text: "確認中の発話"),
            .speechActivity(operation: old), .silenceBegan(operation: old),
            .evaluationFinished(operation: old, questions: evaluated),
            .timeAdvanced, .continueSpeaking, .resultsWillDisplay,
            .movementCheck(operation: previousObservation, gaze: nil, head: nil),
            .trackingAvailability(operation: previousObservation, gaze: false, head: false)
        ]
        for event in ignored { #expect(try session.handle(event, at: time + .seconds(5)).isEmpty) }
        #expect(session.phase == target)
        #expect(session.turns == previousTurns)
        #expect(session.termination == previousTermination)
        #expect(session.result == nil)
        #expect(session.activeOperation == previousOperation)
        #expect(session.observationOperation == previousObservation)

        time += .seconds(10)
        let commands = try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: time)
        #expect(commands == [.resumeInterviewWork(
            confirmation: confirmation, phase: target, previousOperation: previousOperation,
            operation: session.activeOperation, observation: session.observationOperation
        )])
        #expect(session.phase == target)
        #expect(session.turns == previousTurns)
        #expect(session.exitConfirmationPause == nil)
        #expect(session.observationOperation != previousObservation)
        if previousOperation != nil { #expect(session.activeOperation != previousOperation) }
        try session.handle(.evaluationFinished(operation: old, questions: evaluated), at: time)
        #expect(session.phase == target)

        switch target {
        case .preparingQuestion:
            try session.handle(.questionPrepared(operation: operation(session), text: "質問"), at: time)
            #expect(session.phase == .playingQuestion)
        case .playingQuestion, .playingRepeatPrompt:
            try session.handle(.playbackFinished(operation: operation(session)), at: time)
            #expect(session.phase == .startingRecognition)
        case .startingRecognition:
            try session.handle(.recognitionStarted(operation: operation(session)), at: time)
            #expect(session.phase == .waitingForSpeech)
        case .waitingForSpeech, .answering:
            try session.handle(.newSpeechSegment(operation: operation(session), text: "再開後の発話"), at: time)
            #expect(session.phase == .answering)
        case .preparingRepeatPrompt:
            try session.handle(.repeatPromptPrepared(operation: operation(session), text: "再質問"), at: time)
            #expect(session.phase == .playingRepeatPrompt)
        case .evaluating:
            try session.handle(.evaluationFinished(operation: operation(session), questions: evaluated), at: time)
            #expect(session.phase == .resultsReady)
        case .resultsReady:
            try session.handle(.resultsWillDisplay, at: time)
            #expect(session.phase == .resultsDisplayed)
            #expect(session.isEligibleForHistory)
            #expect(session.outcome == .completed(try #require(session.result)))
        default: Issue.record("시험 대상 단계가 일치하지 않습니다")
        }
    }

    @Test(arguments: [
        InterviewPhase.preparingQuestion, .playingQuestion, .startingRecognition,
        .waitingForSpeech, .answering, .preparingRepeatPrompt, .playingRepeatPrompt,
        .evaluating, .resultsReady
    ])
    func confirmedExitEndsEveryActivePhaseWithoutScoresOrHistory(target: InterviewPhase) throws {
        var (session, time) = try fixture(in: target, exclusions: [])
        let oldWork = session.activeOperation
        let observation = session.observationOperation
        let outside = try ScreenPosition(x: -1, y: -1)
        try session.handle(.movementCheck(operation: observation, gaze: outside, head: outside), at: time)
        try session.handle(.trackingAvailability(operation: observation, gaze: false, head: true), at: time)
        let assessment = try session.movement.assessment
        time += .milliseconds(500)
        try session.handle(.exitConfirmationPresented, at: time)
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        #expect(session.outcome == nil)
        #expect(!session.isEligibleForHistory)
        let commands = try session.handle(.exitConfirmationConfirmed(confirmation: confirmation), at: time + .seconds(10))
        #expect(commands == [.endWithoutScore(reason: .userConfirmedExit, operation: oldWork, observation: observation)])
        #expect(session.phase == .endedWithoutScore)
        #expect(session.termination == .userConfirmedExit)
        #expect(session.outcome == .endedWithoutScore(.userConfirmedExit))
        #expect(session.result == nil)
        #expect(session.activeOperation == nil)
        #expect(session.exitConfirmationPause == nil)
        #expect(!session.isMovementScoringInterval)
        #expect(!session.isEligibleForHistory)
        #expect(try session.movement.assessment == assessment)
        let old = oldWork ?? InterviewOperationID(rawValue: 0)
        let lateEvents: [InterviewEvent] = [
            .exitConfirmationCancelled(confirmation: confirmation),
            .exitConfirmationConfirmed(confirmation: confirmation), .exitConfirmationPresented,
            .questionPrepared(operation: old, text: "遅れた質問"),
            .repeatPromptPrepared(operation: old, text: "遅れた再質問"),
            .playbackFinished(operation: old), .recognitionStarted(operation: old),
            .newSpeechSegment(operation: old, text: "遅れた発話"),
            .speechActivity(operation: old), .silenceBegan(operation: old),
            .evaluationFinished(operation: old, questions: try grades(session)),
            .resultsWillDisplay, .continueSpeaking, .timeAdvanced,
            .movementCheck(operation: observation, gaze: outside, head: outside),
            .trackingAvailability(operation: observation, gaze: false, head: false)
        ]
        for event in lateEvents { #expect(try session.handle(event, at: time + .seconds(20)).isEmpty) }
        #expect(session.result == nil)
        #expect(session.outcome == .endedWithoutScore(.userConfirmedExit))
        #expect(try session.movement.assessment == assessment)
        #expect(!session.isEligibleForHistory)
    }

    @Test func confirmationRequiresTheCurrentlyDisplayedDialog() throws {
        var (session, time) = try fixture(in: .waitingForSpeech)
        let unknown = ExitConfirmationID(rawValue: -1)
        #expect(try session.handle(.exitConfirmationConfirmed(confirmation: unknown), at: time).isEmpty)
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.exitConfirmationPresented, at: time)
        let first = try #require(session.exitConfirmationPause?.confirmation)
        time += .seconds(10)
        #expect(try session.handle(.exitConfirmationConfirmed(confirmation: unknown), at: time).isEmpty)
        #expect(session.exitConfirmationPause?.confirmation == first)
        try session.handle(.exitConfirmationCancelled(confirmation: first), at: time)
        #expect(try session.handle(.exitConfirmationConfirmed(confirmation: first), at: time).isEmpty)
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.exitConfirmationPresented, at: time)
        let second = try #require(session.exitConfirmationPause?.confirmation)
        #expect(second != first)
        #expect(try session.handle(.exitConfirmationConfirmed(confirmation: first), at: time).isEmpty)
        #expect(session.exitConfirmationPause?.confirmation == second)
        #expect(session.outcome == nil)
        try session.handle(.exitConfirmationConfirmed(confirmation: second), at: time)
        #expect(session.outcome == .endedWithoutScore(.userConfirmedExit))
    }

    @Test func aPausedRecognitionStartDoesNotBeginTheSevenSecondWait() throws {
        var (session, time) = try fixture(in: .startingRecognition)
        let old = try operation(session)
        try session.handle(.exitConfirmationPresented, at: time)
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        try session.handle(.recognitionStarted(operation: old), at: .seconds(10))
        time = .seconds(20)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: time)
        try session.handle(.recognitionStarted(operation: old), at: time)
        try session.handle(.timeAdvanced, at: .seconds(40))
        #expect(session.phase == .startingRecognition)
        try session.handle(.recognitionStarted(operation: operation(session)), at: .seconds(40))
        try session.handle(.timeAdvanced, at: .milliseconds(46999))
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.timeAdvanced, at: .seconds(47))
        #expect(session.phase == .preparingRepeatPrompt)
    }

    @Test func repeatedAndContinuedAnswerWaitsAlsoReceiveGrace() throws {
        for continued in [false, true] {
            var (session, time) = try fixture(in: .waitingForSpeech)
            if continued {
                try completeAnswer(&session, at: time)
                time += .seconds(3)
                try session.handle(.continueSpeaking, at: time)
                try session.handle(.recognitionStarted(operation: operation(session)), at: time)
            }
            time += .seconds(7)
            try session.handle(.timeAdvanced, at: time)
            try session.handle(.repeatPromptPrepared(operation: operation(session), text: "再質問"), at: time)
            try session.handle(.playbackFinished(operation: operation(session)), at: time)
            try session.handle(.recognitionStarted(operation: operation(session)), at: time)
            time += .milliseconds(6100)
            try session.handle(.exitConfirmationPresented, at: time)
            let confirmation = try #require(session.exitConfirmationPause?.confirmation)
            time += .seconds(10)
            try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: time)
            try session.handle(.timeAdvanced, at: time + .milliseconds(1899))
            #expect(session.phase == .waitingForSpeech)
            try session.handle(.timeAdvanced, at: time + .milliseconds(1900))
            #expect(session.termination == (continued ? .failedContinuation : .newQuestionNonresponse))
        }
    }

    @Test func responseGraceNeverExtendsTheTrackingGapClock() throws {
        var (session, _) = try fixture(in: .waitingForSpeech, exclusions: [])
        let observation = session.observationOperation
        try session.handle(.trackingAvailability(operation: observation, gaze: false, head: true), at: .milliseconds(4900))
        try session.handle(.exitConfirmationPresented, at: .milliseconds(6100))
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .milliseconds(16100))
        try session.handle(.timeAdvanced, at: .milliseconds(17899))
        #expect(session.movement.exclusions.isEmpty)
        let excluded = try session.handle(.timeAdvanced, at: .milliseconds(17900))
        #expect(excluded == [.notifyMovementExcluded([.interviewTrackingUnavailable])])
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.timeAdvanced, at: .seconds(18))
        #expect(session.phase == .preparingRepeatPrompt)
    }

    @Test func aResumedContinuedAnswerKeepsItsOriginalCompletionCredit() throws {
        var (session, time) = try fixture(in: .waitingForSpeech)
        try completeAnswer(&session, at: time)
        time += .seconds(3)
        try session.handle(.continueSpeaking, at: time)
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
        try session.handle(.newSpeechSegment(operation: operation(session), text: "追加"), at: time)
        try session.handle(.silenceBegan(operation: operation(session)), at: time)
        time += .milliseconds(2100)
        try session.handle(.exitConfirmationPresented, at: time)
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        time += .seconds(10)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: time)
        #expect(session.silenceCountdownRemaining(at: time) == .milliseconds(1900))
        try session.handle(.timeAdvanced, at: time + .milliseconds(1900))
        #expect(session.completedQuestionCount == 1)
        #expect(session.turns[0].answerSegments == ["回答", "追加"])
    }

    @Test func aZeroLengthDialogPreservesTheOriginalDeadline() throws {
        var (session, _) = try fixture(in: .waitingForSpeech)
        try session.handle(.exitConfirmationPresented, at: .seconds(2))
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        #expect(throws: InterviewSessionError.invalidTime) {
            try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .seconds(1))
        }
        #expect(session.exitConfirmationPause?.confirmation == confirmation)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .seconds(2))
        try session.handle(.timeAdvanced, at: .milliseconds(6999))
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.timeAdvanced, at: .seconds(7))
        #expect(session.phase == .preparingRepeatPrompt)
    }

    private func fixture(in target: InterviewPhase, exclusions: Set<MovementExclusionReason> = [.settingDisabled]) throws -> (InterviewSession, Duration) {
        var session = InterviewSession(configuration: try InterviewConfiguration(questionCount: 3), movementExclusions: exclusions)
        var time = Duration.zero
        try session.handle(.start, at: time)
        if target == .preparingQuestion { return (session, time) }
        if target == .evaluating || target == .resultsReady {
            for _ in 1...3 {
                try questionToRecognition(&session, at: time)
                try session.handle(.recognitionStarted(operation: operation(session)), at: time)
                try completeAnswer(&session, at: time)
                time += .seconds(3)
            }
            if target == .resultsReady {
                try session.handle(.evaluationFinished(operation: operation(session), questions: grades(session)), at: time)
            }
            return (session, time)
        }
        try session.handle(.questionPrepared(operation: operation(session), text: "質問"), at: time)
        if target == .playingQuestion { return (session, time) }
        try session.handle(.playbackFinished(operation: operation(session)), at: time)
        if target == .startingRecognition { return (session, time) }
        try session.handle(.recognitionStarted(operation: operation(session)), at: time)
        if target == .waitingForSpeech { return (session, time) }
        if target == .answering {
            try session.handle(.newSpeechSegment(operation: operation(session), text: "回答"), at: time)
            return (session, time)
        }
        time = .seconds(7)
        try session.handle(.timeAdvanced, at: time)
        if target == .preparingRepeatPrompt { return (session, time) }
        try session.handle(.repeatPromptPrepared(operation: operation(session), text: "再質問"), at: time)
        return (session, time)
    }

    private func operation(_ session: InterviewSession) throws -> InterviewOperationID {
        try #require(session.activeOperation)
    }

    private func questionToRecognition(_ session: inout InterviewSession, at time: Duration) throws {
        try session.handle(.questionPrepared(operation: operation(session), text: "質問"), at: time)
        try session.handle(.playbackFinished(operation: operation(session)), at: time)
    }

    private func completeAnswer(_ session: inout InterviewSession, at time: Duration) throws {
        try session.handle(.newSpeechSegment(operation: operation(session), text: "回答"), at: time)
        try session.handle(.silenceBegan(operation: operation(session)), at: time)
        try session.handle(.timeAdvanced, at: time + .seconds(3))
    }

    private func grades(_ session: InterviewSession) throws -> [QuestionScores] {
        let score = try Score(numerator: 75)
        return try session.completedTurns.map {
            try QuestionScores(questionNumber: $0.questionNumber, structure: score, logic: score, realism: score)
        }
    }
}
