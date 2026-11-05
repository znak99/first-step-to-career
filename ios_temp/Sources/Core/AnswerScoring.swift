enum AnswerScoringError: Error, Equatable {
    case invalidRubricRatings
    case invalidQuestionNumber
    case duplicateQuestionNumber
}

struct RubricRatings: Equatable, Sendable {
    let criteria: [Int]

    init(_ criteria: [Int]) throws {
        guard criteria.count == 4, criteria.allSatisfy({ (0...2).contains($0) }) else {
            throw AnswerScoringError.invalidRubricRatings
        }
        self.criteria = criteria
    }

    var score: Score {
        get throws { try Score(numerator: criteria.reduce(0, +) * 100, denominator: 8) }
    }
}

struct QuestionScores: Equatable, Sendable {
    let questionNumber: Int
    let structure: Score
    let logic: Score
    let realism: Score

    init(questionNumber: Int, structure: Score, logic: Score, realism: Score) throws {
        guard (1...7).contains(questionNumber) else { throw AnswerScoringError.invalidQuestionNumber }
        self.questionNumber = questionNumber
        self.structure = structure
        self.logic = logic
        self.realism = realism
    }

    init(questionNumber: Int, structure: RubricRatings, logic: RubricRatings, realism: RubricRatings) throws {
        try self.init(questionNumber: questionNumber, structure: structure.score, logic: logic.score, realism: realism.score)
    }
}

struct AnswerCategoryScores: Equatable, Sendable {
    let structure: Score
    let logic: Score
    let realism: Score
}

enum AnswerScoring {
    static func average(completedQuestions: [QuestionScores]) throws -> AnswerCategoryScores? {
        guard !completedQuestions.isEmpty else { return nil }
        guard Set(completedQuestions.map(\.questionNumber)).count == completedQuestions.count else {
            throw AnswerScoringError.duplicateQuestionNumber
        }
        return try AnswerCategoryScores(
            structure: Score.weightedMean(completedQuestions.map { ($0.structure, 1) }),
            logic: Score.weightedMean(completedQuestions.map { ($0.logic, 1) }),
            realism: Score.weightedMean(completedQuestions.map { ($0.realism, 1) })
        )
    }
}
