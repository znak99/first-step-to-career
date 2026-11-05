enum InterviewTerminationReason: Equatable, Sendable {
    case completed
    case newQuestionNonresponse
    case failedContinuation
}

struct MovementCategoryScores: Equatable, Sendable {
    let gaze: Score
    let head: Score
}

struct InterviewScores: Equatable, Sendable {
    let answers: AnswerCategoryScores?
    let movement: MovementCategoryScores?
    let quality: Score?
    let overall: Score
}

enum OverallScoringError: Error, Equatable {
    case inconsistentCompletion
}

enum OverallScoring {
    static func calculate(
        configuration: InterviewConfiguration,
        completedQuestions: [QuestionScores],
        movement: MovementCategoryScores?,
        termination: InterviewTerminationReason
    ) throws -> InterviewScores {
        let count = completedQuestions.count
        guard count <= configuration.questionCount,
              completedQuestions.allSatisfy({ $0.questionNumber <= configuration.questionCount }) else {
            throw OverallScoringError.inconsistentCompletion
        }
        switch termination {
        case .completed:
            guard count == configuration.questionCount else { throw OverallScoringError.inconsistentCompletion }
        case .newQuestionNonresponse:
            guard count < configuration.questionCount else { throw OverallScoringError.inconsistentCompletion }
        case .failedContinuation:
            guard count > 0 else { throw OverallScoringError.inconsistentCompletion }
        }
        guard let answers = try AnswerScoring.average(completedQuestions: completedQuestions) else {
            return InterviewScores(answers: nil, movement: movement, quality: nil, overall: .zero)
        }
        var entries: [(Score, Int)] = [(answers.structure, 25), (answers.logic, 30), (answers.realism, 25)]
        if let movement {
            entries += [(movement.gaze, 10), (movement.head, 10)]
        }
        let quality = try Score.weightedMean(entries)
        let adjusted = try quality.scaled(by: count, over: configuration.questionCount)
        let overall = try termination == .failedContinuation ? adjusted.subtractingWithFloor(5) : adjusted
        return InterviewScores(answers: answers, movement: movement, quality: quality, overall: overall)
    }
}
