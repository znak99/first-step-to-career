enum InterviewConfigurationError: Error, Equatable {
    case questionCountOutOfRange(Int)
}

struct InterviewConfiguration: Equatable, Sendable {
    static let defaultQuestionCount = 5
    static let allowedQuestionCounts = 3...7

    let questionCount: Int

    init(questionCount: Int = Self.defaultQuestionCount) throws {
        guard Self.allowedQuestionCounts.contains(questionCount) else {
            throw InterviewConfigurationError.questionCountOutOfRange(questionCount)
        }
        self.questionCount = questionCount
    }
}
