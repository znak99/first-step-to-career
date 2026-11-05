import Testing
@testable import FirstStepToCareer

@MainActor
struct ViewModelTests {
    @Test func launchMovesFromSplashToOnboardingToMain() async {
        let viewModel = LaunchViewModel()
        #expect(viewModel.phase == .splash)
        await viewModel.showSplash(for: .zero)
        #expect(viewModel.phase == .onboarding)
        viewModel.start()
        #expect(viewModel.phase == .main)
    }

    @Test func cancelledSplashStaysOnSplash() async {
        let viewModel = LaunchViewModel()
        let task = Task { await viewModel.showSplash(for: .seconds(60)) }
        task.cancel()
        await task.value
        #expect(viewModel.phase == .splash)
    }

    @Test func settingsStartWithApprovedDefaults() {
        let viewModel = SettingsViewModel()
        #expect(viewModel.questionCount == 5)
        #expect(viewModel.allowedQuestionCounts == 3...7)
        #expect(viewModel.movementScoringEnabled)
    }

    @Test func setupStartsEmpty() {
        let viewModel = MockInterviewSetupViewModel()
        #expect(viewModel.company.isEmpty)
        #expect(viewModel.industry.isEmpty)
        #expect(viewModel.role.isEmpty)
        #expect(viewModel.interviewType.isEmpty)
    }
}
