import SwiftUI

struct MockInterviewView: View {
    let questionCount: Int

    @State private var viewModel = MockInterviewSetupViewModel()

    var body: some View {
        Form {
            Section {
                Label {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("練習を、次の自信に。")
                            .font(.headline)
                        Text("応募先に合わせて、面接の準備をしましょう。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundStyle(.teal)
                }
                .padding(.vertical, 8)
            }

            Section("面接の条件") {
                TextField("会社名", text: $viewModel.company)
                    .accessibilityIdentifier("setup.company")
                TextField("業種", text: $viewModel.industry)
                    .accessibilityIdentifier("setup.industry")
                TextField("職種", text: $viewModel.role)
                    .accessibilityIdentifier("setup.role")
                Picker("面接の種類", selection: $viewModel.interviewType) {
                    Text("選択してください").tag("")
                    Text("人事面接").tag("hr")
                    Text("職種別面接").tag("jobSpecific")
                }
                .accessibilityIdentifier("setup.interviewType")
            }

            Section {
                LabeledContent("質問数", value: "\(questionCount)問")
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("質問数")
                    .accessibilityValue("\(questionCount)問")
                    .accessibilityIdentifier("setup.questionCount")
            } footer: {
                Text("質問数はメニューから変更できます。")
            }

            Section {
                NavigationLink {
                    InterviewPreparationView()
                } label: {
                    Label("面接の準備へ", systemImage: "arrow.right.circle.fill")
                }
                .accessibilityIdentifier("setup.prepare")
            }
        }
        .navigationTitle("模擬面接")
    }
}

struct InterviewPreparationView: View {
    var body: some View {
        List {
            Section {
                Label("静かな場所で、画面に向かって座りましょう。", systemImage: "person.crop.rectangle")
                    .padding(.vertical, 8)
            }

            Section("確認すること") {
                LabeledContent("マイク", value: "未確認")
                LabeledContent("カメラ", value: "未確認")
                LabeledContent("姿勢と画面との距離", value: "未確認")
            }

            Section {
                NavigationLink {
                    InterviewView()
                } label: {
                    Label("面接画面へ", systemImage: "arrow.right.circle.fill")
                }
                .accessibilityIdentifier("preparation.openInterview")
            } footer: {
                Text("音声とカメラを使った面接は準備中です。")
            }
        }
        .navigationTitle("面接の準備")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InterviewView: View {
    var body: some View {
        VStack {
            EmptyStateView(
                title: "面接は準備中です",
                systemImage: "mic",
                message: "質問の読み上げや、声での回答ができるようになります。"
            )

            NavigationLink {
                InterviewResultView()
            } label: {
                Text("結果画面へ")
                    .frame(maxWidth: .infinity, minHeight: 36)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityIdentifier("interview.openResult")
            .padding(24)
        }
        .navigationTitle("面接")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InterviewResultView: View {
    var body: some View {
        EmptyStateView(
            title: "まだ面接結果がありません",
            systemImage: "checkmark.bubble",
            message: "面接を完了すると、評価と質問・回答をここで確認できます。"
        )
        .navigationTitle("面接結果")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MockInterviewView(questionCount: 5)
    }
    .tint(.teal)
}
