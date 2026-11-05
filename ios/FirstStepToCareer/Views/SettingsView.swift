import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("面接の設定") {
                Stepper(value: $viewModel.questionCount, in: viewModel.allowedQuestionCounts) {
                    LabeledContent("質問数", value: "\(viewModel.questionCount)問")
                }
                .accessibilityIdentifier("settings.questionCount")

                Toggle("視線・頭の動きを評価", isOn: $viewModel.movementScoringEnabled)
                    .accessibilityIdentifier("settings.movementScoring")
            }

            Section {
                Label("就活一歩", systemImage: "figure.walk.circle")
            } footer: {
                Text("設定はアプリを開いている間のみ保持されます。")
            }
        }
        .navigationTitle("メニュー")
    }
}

#Preview {
    NavigationStack {
        SettingsView(viewModel: SettingsViewModel())
    }
}
