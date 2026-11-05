import Testing
@testable import FirstStepToCareer

struct ExitConfirmationTests {
    @Test func sevenSecondWaitPreservesFiveSecondsAfterTenSecondPause() throws {
        var session = try waitingSession()
        let oldOperation = try operation(session)
        let confirmation = try pause(&session, at: .seconds(2))
        #expect(session.phase == .waitingForSpeech)
        #expect(!session.isMovementScoringInterval)
        try session.handle(.timeAdvanced, at: .seconds(12))
        #expect(session.phase == .waitingForSpeech)
        let resumed = try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .seconds(12))
        #expect(resumed.count == 1)
        #expect(session.activeOperation != oldOperation)
        try session.handle(.timeAdvanced, at: .milliseconds(16999))
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.timeAdvanced, at: .seconds(17))
        #expect(session.phase == .preparingRepeatPrompt)
    }

    @Test func silenceCountdownAndAnswerAreFrozenUntilCancellation() throws {
        var session = try waitingSession()
        let recognition = try operation(session)
        try session.handle(.newSpeechSegment(operation: recognition, text: "元の回答"), at: .zero)
        try session.handle(.silenceBegan(operation: recognition), at: .zero)
        let confirmation = try pause(&session, at: .seconds(1))
        #expect(session.silenceCountdownRemaining(at: .seconds(20)) == .seconds(2))
        try session.handle(.newSpeechSegment(operation: recognition, text: "確認中の発話"), at: .seconds(20))
        try session.handle(.speechActivity(operation: recognition), at: .seconds(20))
        try session.handle(.timeAdvanced, at: .seconds(20))
        #expect(session.turns[0].answerSegments == ["元の回答"])
        #expect(session.completedQuestionCount == 0)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .seconds(21))
        try session.handle(.newSpeechSegment(operation: recognition, text: "遅れた発話"), at: .seconds(21))
        #expect(session.turns[0].answerSegments == ["元の回答"])
        try session.handle(.timeAdvanced, at: .milliseconds(22999))
        #expect(session.completedQuestionCount == 0)
        try session.handle(.timeAdvanced, at: .seconds(23))
        #expect(session.completedQuestionCount == 1)
    }

    @Test func trackingGapClockExcludesTheDialogAndDeductionsRemainFrozen() throws {
        var session = try waitingSession(exclusions: [])
        let outside = try ScreenPosition(x: -1, y: 0.5)
        let center = try ScreenPosition(x: 0.5, y: 0.5)
        let oldObservation = session.observationOperation
        try session.handle(.movementCheck(operation: oldObservation, gaze: center, head: center), at: .zero)
        try session.handle(.trackingAvailability(operation: oldObservation, gaze: false, head: true), at: .zero)
        let confirmation = try pause(&session, at: .seconds(2))
        try session.handle(.movementCheck(operation: oldObservation, gaze: outside, head: outside), at: .seconds(50))
        try session.handle(.trackingAvailability(operation: oldObservation, gaze: true, head: true), at: .seconds(50))
        try session.handle(.timeAdvanced, at: .seconds(100))
        #expect(session.movement.exclusions.isEmpty)
        #expect(try session.movement.scoresForOverall()?.head == .hundred)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .seconds(102))
        try session.handle(.trackingAvailability(operation: oldObservation, gaze: true, head: true), at: .seconds(102))
        try session.handle(.timeAdvanced, at: .milliseconds(102999))
        #expect(session.movement.exclusions.isEmpty)
        let commands = try session.handle(.timeAdvanced, at: .seconds(103))
        #expect(commands == [.notifyMovementExcluded([.interviewTrackingUnavailable])])
    }

    @Test func oldObservationsAreNotAppliedAfterResuming() throws {
        var session = InterviewSession(configuration: try InterviewConfiguration(), movementExclusions: [])
        try session.handle(.start, at: .zero)
        let oldOperation = try operation(session)
        let oldObservation = session.observationOperation
        let center = try ScreenPosition(x: 0.5, y: 0.5)
        let outside = try ScreenPosition(x: -1, y: 0.5)
        try session.handle(.movementCheck(operation: oldObservation, gaze: center, head: center), at: .zero)
        let confirmation = try pause(&session, at: .seconds(1))
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: .seconds(11))
        #expect(session.observationOperation != oldObservation)
        try session.handle(.movementCheck(operation: oldObservation, gaze: outside, head: outside), at: .seconds(11))
        try session.handle(.trackingAvailability(operation: oldObservation, gaze: false, head: false), at: .seconds(11))
        try session.handle(.questionPrepared(operation: oldOperation, text: "古い質問"), at: .seconds(11))
        #expect(session.phase == .preparingQuestion)
        try session.handle(.timeAdvanced, at: .seconds(15))
        #expect(session.movement.exclusions.isEmpty)
        #expect(try session.movement.scoresForOverall()?.gaze == .hundred)
        try session.handle(.movementCheck(operation: session.observationOperation, gaze: outside, head: center), at: .seconds(15))
        #expect(try session.movement.scoresForOverall()?.gaze.formatted == "99.6")
        try session.handle(.questionPrepared(operation: operation(session), text: "再開した質問"), at: .seconds(15))
        #expect(session.phase == .playingQuestion)
    }

    @Test func multipleDialogsDoNotAccumulatePausedTimeOrAcceptOldCancellation() throws {
        var session = try waitingSession()
        let first = try pause(&session, at: .seconds(1))
        try session.handle(.exitConfirmationCancelled(confirmation: first), at: .seconds(11))
        let second = try pause(&session, at: .seconds(12))
        try session.handle(.exitConfirmationCancelled(confirmation: first), at: .seconds(20))
        #expect(session.exitConfirmationPause?.confirmation == second)
        try session.handle(.exitConfirmationPresented, at: .seconds(20))
        #expect(session.exitConfirmationPause?.confirmation == second)
        try session.handle(.exitConfirmationCancelled(confirmation: second), at: .seconds(22))
        try session.handle(.timeAdvanced, at: .milliseconds(26999))
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.timeAdvanced, at: .seconds(27))
        #expect(session.phase == .preparingRepeatPrompt)
    }

    @Test(arguments: [(6100, 1899, 1900), (6000, 999, 1000)])
    func waitingGraceUsesTheUnroundedLessThanOneSecondBoundary(pausedMilliseconds: Int, beforeDeadline: Int, deadline: Int) throws {
        var session = try waitingSession()
        let opened = Duration.milliseconds(pausedMilliseconds)
        let confirmation = try pause(&session, at: opened)
        let resumed = opened + .seconds(10)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: resumed)
        try session.handle(.timeAdvanced, at: resumed + .milliseconds(beforeDeadline))
        #expect(session.phase == .waitingForSpeech)
        try session.handle(.timeAdvanced, at: resumed + .milliseconds(deadline))
        #expect(session.phase == .preparingRepeatPrompt)
    }

    @Test(arguments: [(2100, 1900), (2000, 1000)])
    func silenceGraceDoesNotExtendAnExactlyOneSecondRemainder(pausedMilliseconds: Int, remainingMilliseconds: Int) throws {
        var session = try waitingSession()
        let recognition = try operation(session)
        try session.handle(.newSpeechSegment(operation: recognition, text: "回答"), at: .zero)
        try session.handle(.silenceBegan(operation: recognition), at: .zero)
        let opened = Duration.milliseconds(pausedMilliseconds)
        let confirmation = try pause(&session, at: opened)
        let resumed = opened + .seconds(10)
        try session.handle(.exitConfirmationCancelled(confirmation: confirmation), at: resumed)
        #expect(session.silenceCountdownRemaining(at: resumed) == .milliseconds(remainingMilliseconds))
        try session.handle(.timeAdvanced, at: resumed + .milliseconds(remainingMilliseconds - 1))
        #expect(session.completedQuestionCount == 0)
        try session.handle(.timeAdvanced, at: resumed + .milliseconds(remainingMilliseconds))
        #expect(session.completedQuestionCount == 1)
    }

    @Test func anUnorderedZeroDeadlineNeedsAnExplicitRuntimeDecision() throws {
        var session = try waitingSession()
        #expect(throws: InterviewSessionError.approvalRequired(.exitConfirmationAtResponseDeadline)) {
            try session.handle(.exitConfirmationPresented, at: .seconds(7))
        }
        #expect(session.exitConfirmationPause == nil)
        #expect(session.phase == .waitingForSpeech)
    }

    private func waitingSession(exclusions: Set<MovementExclusionReason> = [.settingDisabled]) throws -> InterviewSession {
        var session = InterviewSession(configuration: try InterviewConfiguration(), movementExclusions: exclusions)
        try session.handle(.start, at: .zero)
        try session.handle(.questionPrepared(operation: operation(session), text: "質問"), at: .zero)
        try session.handle(.playbackFinished(operation: operation(session)), at: .zero)
        try session.handle(.recognitionStarted(operation: operation(session)), at: .zero)
        return session
    }

    private func operation(_ session: InterviewSession) throws -> InterviewOperationID {
        try #require(session.activeOperation)
    }

    private func pause(_ session: inout InterviewSession, at time: Duration) throws -> ExitConfirmationID {
        let previousPhase = session.phase
        let commands = try session.handle(.exitConfirmationPresented, at: time)
        let confirmation = try #require(session.exitConfirmationPause?.confirmation)
        #expect(session.exitConfirmationPause?.phase == previousPhase)
        #expect(commands == [.suspendInterviewWork(
            confirmation: confirmation, phase: previousPhase, operation: session.activeOperation,
            observation: session.observationOperation
        )])
        return confirmation
    }
}
