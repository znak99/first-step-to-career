import Observation

@MainActor
@Observable
final class SettingsViewModel {
    let allowedQuestionCounts = InterviewConfiguration.allowedQuestionCounts
    var questionCount = InterviewConfiguration.defaultQuestionCount
    var movementScoringEnabled = true
}
