import Foundation
import LocalLLMRuntime

@main
struct LLMSmoke {
    static func main() async throws {
        guard CommandLine.arguments.count == 2 else {
            throw LocalLLMError.missingFile("モデルのディレクトリを指定してください")
        }
        let service = LocalLLMService()
        let directory = URL(fileURLWithPath: CommandLine.arguments[1])
        try await service.generate(
            prompt: "日本語で「こんにちは」とだけ答えてください。", directory: directory, maxTokens: 32
        ) { chunk in
            print(chunk, terminator: "")
        }
        print()

        let cancelled = Task {
            try await service.generate(
                prompt: "日本語で面接の準備について詳しく説明してください。", directory: directory
            ) { _ in
                withUnsafeCurrentTask { $0?.cancel() }
            }
        }
        do {
            try await cancelled.value
            throw SmokeError.cancellationDidNotStopGeneration
        } catch is CancellationError {
            print("생성 중 취소 확인")
        }

        try await service.generate(
            prompt: "日本語で「ありがとう」とだけ答えてください。", directory: directory, maxTokens: 32
        ) { chunk in
            print(chunk, terminator: "")
        }
        print()
    }

    private enum SmokeError: Error {
        case cancellationDidNotStopGeneration
    }
}
