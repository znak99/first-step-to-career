nonisolated enum InterviewTerminationReason: Equatable, Sendable {
    case completed
    case newQuestionNonresponse
    case failedContinuation
    case userConfirmedExit
}

nonisolated struct MovementCategoryScores: Equatable, Sendable {
    let gaze: Score
    let head: Score
}

nonisolated struct InterviewScores: Equatable, Sendable {
    let answers: AnswerCategoryScores?
    let movement: MovementCategoryScores?
    let quality: Score?
    let overall: Score
}

nonisolated enum InterviewOutcome: Equatable, Sendable {
    case completed(InterviewScores)
    case endedWithoutScore(InterviewTerminationReason)
}

nonisolated enum OverallScoringError: Error, Equatable {
    case inconsistentCompletion
}

nonisolated enum OverallScoring {
    static func calculate(
        configuration: InterviewConfiguration,
        completedQuestions: [QuestionScores],
        movement: MovementCategoryScores?,
        termination: InterviewTerminationReason
    ) throws -> InterviewScores? {
        guard termination == .completed else { return nil }
        let count = completedQuestions.count
        guard count <= configuration.questionCount,
              completedQuestions.allSatisfy({ $0.questionNumber <= configuration.questionCount }) else {
            throw OverallScoringError.inconsistentCompletion
        }
        guard count == configuration.questionCount else { throw OverallScoringError.inconsistentCompletion }
        guard let answers = try AnswerScoring.average(completedQuestions: completedQuestions) else {
            throw OverallScoringError.inconsistentCompletion
        }
        var entries: [(Score, Int)] = [(answers.structure, 25), (answers.logic, 30), (answers.realism, 25)]
        if let movement {
            entries += [(movement.gaze, 10), (movement.head, 10)]
        }
        let quality = try Score.weightedMean(entries)
        return InterviewScores(answers: answers, movement: movement, quality: quality, overall: quality)
    }
}
