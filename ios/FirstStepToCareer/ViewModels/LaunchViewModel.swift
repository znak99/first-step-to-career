import Observation

@MainActor
@Observable
final class LaunchViewModel {
    enum Phase {
        case splash
        case onboarding
        case main
    }

    private(set) var phase: Phase = .splash

    func showSplash(for duration: Duration = .milliseconds(800)) async {
        do {
            try await Task.sleep(for: duration)
            phase = .onboarding
        } catch {
            return
        }
    }

    func start() {
        phase = .main
    }
}
