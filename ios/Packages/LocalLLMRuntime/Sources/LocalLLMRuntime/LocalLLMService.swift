import Foundation
import MLXLLM
import MLXLMCommon
import Tokenizers

nonisolated public enum LocalLLMError: LocalizedError, Equatable {
    case emptyPrompt
    case missingFile(String)
    case alreadyRunning

    public var errorDescription: String? {
        switch self {
        case .emptyPrompt: "入力する文章を記入してください。"
        case .missingFile(let name): "モデルファイルが見つかりません: \(name)"
        case .alreadyRunning: "生成が終わるまでお待ちください。"
        }
    }
}

public actor LocalLLMService {
    private var model: ModelContainer?
    private var loadedDirectory: URL?
    private var running = false

    public init() {}

    public func generate(
        prompt: String,
        directory: URL,
        maxTokens: Int = 256,
        onChunk: @Sendable (String) async -> Void
    ) async throws {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw LocalLLMError.emptyPrompt
        }
        guard !running else { throw LocalLLMError.alreadyRunning }
        running = true
        defer { running = false }
        try Task.checkCancellation()
        for name in ["config.json", "model.safetensors", "tokenizer.json", "tokenizer_config.json", "chat_template.jinja"] {
            guard FileManager.default.fileExists(atPath: directory.appendingPathComponent(name).path) else {
                throw LocalLLMError.missingFile(name)
            }
        }
        if model == nil || loadedDirectory != directory {
            model = nil
            loadedDirectory = nil
            let loaded = try await LLMModelFactory.shared.loadContainer(
                from: directory, using: LocalTokenizerLoader()
            )
            try Task.checkCancellation()
            model = loaded
            loadedDirectory = directory
        }
        guard let model else { throw LocalLLMError.missingFile("model.safetensors") }
        let session = ChatSession(model, generateParameters: GenerateParameters(
            maxTokens: maxTokens, temperature: 0.1, topK: 50, repetitionPenalty: 1.05
        ))
        for try await chunk in session.streamResponse(to: prompt) {
            try Task.checkCancellation()
            await onChunk(chunk)
        }
        try Task.checkCancellation()
    }
}

nonisolated private struct LocalTokenizerLoader: MLXLMCommon.TokenizerLoader {
    func load(from directory: URL) async throws -> any MLXLMCommon.Tokenizer {
        let template = try String(contentsOf: directory.appendingPathComponent("chat_template.jinja"), encoding: .utf8)
        let tokenizer = try await AutoTokenizer.from(modelFolder: directory)
        return LocalTokenizer(base: tokenizer, template: template)
    }
}

nonisolated private struct LocalTokenizer: MLXLMCommon.Tokenizer {
    let base: any Tokenizers.Tokenizer
    let template: String

    var bosToken: String? { base.bosToken }
    var eosToken: String? { base.eosToken }
    var unknownToken: String? { base.unknownToken }

    func encode(text: String, addSpecialTokens: Bool) -> [Int] {
        base.encode(text: text, addSpecialTokens: addSpecialTokens)
    }

    func decode(tokenIds: [Int], skipSpecialTokens: Bool) -> String {
        base.decode(tokens: tokenIds, skipSpecialTokens: skipSpecialTokens)
    }

    func convertTokenToId(_ token: String) -> Int? { base.convertTokenToId(token) }
    func convertIdToToken(_ id: Int) -> String? { base.convertIdToToken(id) }

    func applyChatTemplate(
        messages: [[String: any Sendable]],
        tools: [[String: any Sendable]]?,
        additionalContext: [String: any Sendable]?
    ) throws -> [Int] {
        try base.applyChatTemplate(
            messages: messages, chatTemplate: .literal(template), addGenerationPrompt: true,
            truncation: false, maxLength: nil, tools: tools, additionalContext: additionalContext
        )
    }
}
