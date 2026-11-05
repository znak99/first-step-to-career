import Foundation
import Testing
@testable import LocalLLMRuntime

struct LocalLLMServiceTests {
    @Test func emptyPromptIsRejectedBeforeLoading() async throws {
        let service = LocalLLMService()
        await #expect(throws: LocalLLMError.emptyPrompt) {
            try await service.generate(prompt: " \n\t", directory: missingDirectory()) { _ in }
        }
    }

    @Test func missingFilesDoNotLeaveTheServiceBusy() async throws {
        let service = LocalLLMService()
        for _ in 0..<2 {
            await #expect(throws: LocalLLMError.missingFile("config.json")) {
                try await service.generate(prompt: "こんにちは", directory: missingDirectory()) { _ in }
            }
        }
    }

    @Test func cancelledRequestDoesNotLoadTheModelOrBlockRetry() async throws {
        let service = LocalLLMService()
        let work = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            try await service.generate(prompt: "こんにちは", directory: missingDirectory()) { _ in }
        }
        await #expect(throws: CancellationError.self) { try await work.value }
        await #expect(throws: LocalLLMError.missingFile("config.json")) {
            try await service.generate(prompt: "こんにちは", directory: missingDirectory()) { _ in }
        }
    }

    private func missingDirectory() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }
}
