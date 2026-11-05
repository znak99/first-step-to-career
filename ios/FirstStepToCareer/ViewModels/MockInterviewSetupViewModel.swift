import Observation

@MainActor
@Observable
final class MockInterviewSetupViewModel {
    var company = ""
    var industry = ""
    var role = ""
    var interviewType = ""
}
