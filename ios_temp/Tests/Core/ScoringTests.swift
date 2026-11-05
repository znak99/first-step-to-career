import Testing
@testable import FirstStepToCareer

struct ScoringTests {
    @Test(arguments: [
        ([0, 0, 0, 0], 0), ([2, 2, 2, 2], 100), ([2, 2, 1, 1], 75), ([2, 1, 1, 2], 75)
    ])
    func approvedRubricExamples(criteria: [Int], expected: Int) throws {
        #expect(try RubricRatings(criteria).score == Score(numerator: expected))
    }

    @Test(arguments: [[], [0], [0, 0, 0], [0, 0, 0, 0, 0], [-1, 0, 0, 0], [0, 0, 0, 3]])
    func rejectsInvalidRubricInputs(criteria: [Int]) {
        #expect(throws: AnswerScoringError.invalidRubricRatings) { try RubricRatings(criteria) }
    }

    @Test func completedQuestionsHaveEqualWeightAndNoIntermediateRounding() throws {
        let questions = try [50, 75, 100].enumerated().map { index, value in
            try question(index + 1, value)
        }
        let average = try #require(try AnswerScoring.average(completedQuestions: questions))
        #expect(try average.structure == Score(numerator: 75))
        let thirds = try AnswerScoring.average(completedQuestions: [question(1, 0), question(2, 0), question(3, 100)])
        #expect(try thirds?.logic == Score(numerator: 100, denominator: 3))
        #expect(thirds?.logic.formatted == "33.3")
        #expect(try AnswerScoring.average(completedQuestions: []) == nil)
        #expect(throws: AnswerScoringError.duplicateQuestionNumber) {
            try AnswerScoring.average(completedQuestions: [question(1, 50), question(1, 75)])
        }
    }

    @Test func approvedWeightedExampleAndExcludedMovement() throws {
        let questions = try (1...3).map {
            try QuestionScores(questionNumber: $0, structure: Score(numerator: 80), logic: Score(numerator: 90), realism: Score(numerator: 70))
        }
        let full = try #require(try OverallScoring.calculate(
            configuration: InterviewConfiguration(questionCount: 3), completedQuestions: questions,
            movement: MovementCategoryScores(gaze: Score(numerator: 60), head: Score(numerator: 80)), termination: .completed
        ))
        #expect(try full.overall == Score(numerator: 785, denominator: 10))
        let excluded = try #require(try OverallScoring.calculate(
            configuration: InterviewConfiguration(questionCount: 3), completedQuestions: questions,
            movement: nil, termination: .completed
        ))
        #expect(try excluded.overall == Score(numerator: 645, denominator: 8))
        #expect(excluded.overall.formatted == "80.6")
        #expect(excluded.movement == nil)
    }

    @Test(arguments: [
        InterviewTerminationReason.newQuestionNonresponse, .failedContinuation, .userConfirmedExit
    ])
    func earlyTerminationNeverProducesScores(reason: InterviewTerminationReason) throws {
        for count in [0, 1, 3, 5] {
            let questions = try (0..<count).map { try question($0 + 1, 80) }
            for movement in [nil, try MovementCategoryScores(gaze: Score(numerator: 100), head: Score(numerator: 100))] {
                let result = try OverallScoring.calculate(
                    configuration: InterviewConfiguration(), completedQuestions: questions,
                    movement: movement, termination: reason
                )
                #expect(result == nil)
            }
        }
        // 조기 종료는 답변 평균 계산 자체를 실행하지 않는다.
        #expect(try OverallScoring.calculate(
            configuration: InterviewConfiguration(), completedQuestions: [question(1, 50), question(1, 75)],
            movement: nil, termination: reason
        ) == nil)
    }

    @Test(arguments: [(8234, 100, "82.3"), (8235, 100, "82.4"), (9996, 100, "100.0"), (80, 1, "80.0"), (0, 1, "0.0"), (1, 20, "0.1"), (Int.max - 1, Int.max, "1.0")])
    func roundsOnlyForDisplay(numerator: Int, denominator: Int, expected: String) throws {
        #expect(try Score(numerator: numerator, denominator: denominator).formatted == expected)
    }

    @Test func invalidScoresAndInconsistentCompletionAreRejected() throws {
        #expect(throws: ScoreError.invalidFraction) { try Score(numerator: -1) }
        #expect(throws: ScoreError.invalidFraction) { try Score(numerator: 1, denominator: 0) }
        #expect(throws: ScoreError.outOfRange) { try Score(numerator: 101) }
        #expect(throws: AnswerScoringError.invalidQuestionNumber) { try question(0, 50) }
        #expect(throws: OverallScoringError.inconsistentCompletion) {
            try OverallScoring.calculate(configuration: InterviewConfiguration(), completedQuestions: [], movement: nil, termination: .completed)
        }
    }

    private func question(_ number: Int, _ value: Int) throws -> QuestionScores {
        let score = try Score(numerator: value)
        return try QuestionScores(questionNumber: number, structure: score, logic: score, realism: score)
    }
}
