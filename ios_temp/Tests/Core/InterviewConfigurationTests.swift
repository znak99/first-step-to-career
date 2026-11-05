import Testing
@testable import FirstStepToCareer

struct InterviewConfigurationTests {
    @Test func firstUseHasFiveQuestions() throws {
        #expect(try InterviewConfiguration().questionCount == 5)
    }

    @Test(arguments: [3, 4, 5, 6, 7])
    func acceptsApprovedQuestionCounts(count: Int) throws {
        #expect(try InterviewConfiguration(questionCount: count).questionCount == count)
    }

    @Test(arguments: [Int.min, -1, 0, 2, 8, Int.max])
    func rejectsCountsOutsideApprovedRange(count: Int) {
        #expect(throws: InterviewConfigurationError.questionCountOutOfRange(count)) {
            try InterviewConfiguration(questionCount: count)
        }
    }
}
