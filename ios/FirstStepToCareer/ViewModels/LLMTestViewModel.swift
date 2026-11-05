#if DEBUG
import Foundation
import Observation

@MainActor
@Observable
final class LLMTestViewModel {
    var prompt = "日本語で短く自己紹介してください。"
    private(set) var output = ""
    private(set) var status = "待機中"
    private(set) var errorMessage: String?
    private(set) var isRunning = false
    private let service = LocalLLMService()
    private var work: Task<Void, Never>?

    func generate() {
        guard !isRunning, !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isRunning = true
        errorMessage = nil
        output = ""
        status = "モデルを読み込み中…"
        let input = prompt
        work = Task {
            defer { isRunning = false; work = nil }
            do {
                #if targetEnvironment(simulator)
                throw TestError.simulator
                #else
                guard let directory = Bundle.main.resourceURL?.appendingPathComponent("LocalLLM"),
                      FileManager.default.fileExists(atPath: directory.path) else {
                    throw TestError.missingModel
                }
                try await service.generate(prompt: input, directory: directory) { [weak self] chunk in
                    await self?.append(chunk)
                }
                status = "生成完了"
                #endif
            } catch is CancellationError {
                status = "停止しました"
            } catch {
                errorMessage = error.localizedDescription
                status = "生成できませんでした"
            }
        }
    }

    func cancel() {
        guard isRunning else { return }
        status = "停止中…"
        work?.cancel()
    }

    private func append(_ chunk: String) {
        guard !Task.isCancelled else { return }
        status = "生成中…"
        output += chunk
    }

    private enum TestError: LocalizedError {
        case simulator, missingModel
        var errorDescription: String? {
            switch self {
            case .simulator: "シミュレーターではモデルを実行できません。iPhone実機でお試しください。"
            case .missingModel: "モデルがアプリに含まれていません。ローカルモデルを確認し、Debugでビルドしてください。"
            }
        }
    }
}
#endif
