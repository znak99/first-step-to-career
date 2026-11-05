import SwiftUI

struct SettingsView: View {
    @Binding var questionCount: Int
    @Binding var movementScoringEnabled: Bool

    var body: some View {
        Form {
            Section("面接の設定") {
                Stepper(value: $questionCount, in: InterviewConfiguration.allowedQuestionCounts) {
                    LabeledContent("質問数", value: "\(questionCount)問")
                }
                .accessibilityIdentifier("settings.questionCount")

                Toggle("視線・頭の動きを評価", isOn: $movementScoringEnabled)
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
        SettingsView(questionCount: .constant(5), movementScoringEnabled: .constant(true))
    }
}
