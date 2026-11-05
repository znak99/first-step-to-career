nonisolated struct InterviewOperationID: Hashable, Sendable {
    let rawValue: Int
}

nonisolated struct InterviewTurn: Equatable, Sendable {
    let questionNumber: Int
    let question: String
    var answerSegments: [String] = []
    var isCompleted = false
}

nonisolated enum InterviewPhase: Equatable, Sendable {
    case ready
    case preparingQuestion
    case playingQuestion
    case startingRecognition
    case waitingForSpeech
    case answering
    case preparingRepeatPrompt
    case playingRepeatPrompt
    case evaluating
    case resultsReady
    case resultsDisplayed
}

nonisolated enum InterviewApprovalBoundary: Equatable, Sendable {
    case continuationInPhase(InterviewPhase)
    case movementWithoutObservations
    case continuationAfterNonresponse
}

nonisolated enum InterviewSessionError: Error, Equatable {
    case invalidTransition
    case invalidTime
    case invalidSpeechSegment
    case invalidEvaluation
    case operationLimit
    case approvalRequired(InterviewApprovalBoundary)
}

nonisolated enum InterviewEvent: Sendable {
    case start
    case questionPrepared(operation: InterviewOperationID, text: String)
    case repeatPromptPrepared(operation: InterviewOperationID, text: String)
    case playbackFinished(operation: InterviewOperationID)
    case recognitionStarted(operation: InterviewOperationID)
    case newSpeechSegment(operation: InterviewOperationID, text: String)
    case speechActivity(operation: InterviewOperationID)
    case silenceBegan(operation: InterviewOperationID)
    case timeAdvanced
    case continueSpeaking
    case evaluationFinished(operation: InterviewOperationID, questions: [QuestionScores])
    case resultsWillDisplay
    case movementCheck(gaze: ScreenPosition?, head: ScreenPosition?)
    case trackingAvailability(gaze: Bool, head: Bool)
}

nonisolated enum InterviewCommand: Equatable, Sendable {
    case prepareQuestion(operation: InterviewOperationID, number: Int, completedAnswers: [InterviewTurn])
    case playQuestion(operation: InterviewOperationID, number: Int, text: String)
    case prepareRepeatPrompt(operation: InterviewOperationID, number: Int, originalQuestion: String)
    case playRepeatPrompt(operation: InterviewOperationID, text: String)
    case startRecognition(operation: InterviewOperationID, number: Int, isContinuation: Bool)
    case stopRecognition(operation: InterviewOperationID)
    case cancelQuestionPreparation(operation: InterviewOperationID)
    case stopPlayback(operation: InterviewOperationID)
    case cancelEvaluation(operation: InterviewOperationID)
    case evaluateAnswers(operation: InterviewOperationID, completedAnswers: [InterviewTurn], reason: InterviewTerminationReason)
    case resultsAvailable
    case presentResults(InterviewScores)
    case notifyMovementExcluded(Set<MovementExclusionReason>)
}
