#if DEBUG
import SwiftUI

struct LLMTestView: View {
    @State private var viewModel = LLMTestViewModel()

    var body: some View {
        Form {
            Section("ローカルモデル") {
                Text("LFM2.5-1.2B-JP-202606")
                Text("BF16 · 約2.35GB · 最大256トークン")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(viewModel.status)
                    .accessibilityIdentifier("llm.status")
            }
            Section("入力") {
                TextEditor(text: $viewModel.prompt)
                    .frame(minHeight: 100)
                    .disabled(viewModel.isRunning)
                    .accessibilityLabel("試したい文章")
                    .accessibilityIdentifier("llm.prompt")
                Button("生成する") { viewModel.generate() }
                    .disabled(viewModel.isRunning || viewModel.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityIdentifier("llm.generate")
                if viewModel.isRunning {
                    Button("停止する", role: .cancel) { viewModel.cancel() }
                        .accessibilityIdentifier("llm.stop")
                }
            }
            if let error = viewModel.errorMessage {
                Section("エラー") {
                    Text(error)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("llm.error")
                }
            }
            Section("出力") {
                Text(viewModel.output.isEmpty ? "生成された文章がここに表示されます。" : viewModel.output)
                    .textSelection(.enabled)
                    .accessibilityIdentifier("llm.output")
            }
        }
        .navigationTitle("LLMテスト")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { viewModel.cancel() }
    }
}
#endif
