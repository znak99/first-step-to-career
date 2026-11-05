import SwiftUI

struct InterviewManagementView: View {
    var body: some View {
        List {
            Section("面接を振り返る") {
                NavigationLink {
                    PastInterviewResultsView()
                } label: {
                    Label("過去の面接結果", systemImage: "clock.arrow.circlepath")
                }
                .accessibilityIdentifier("management.history")
            }

            Section("これからの面接") {
                NavigationLink {
                    InterviewScheduleView()
                } label: {
                    Label("面接スケジュール", systemImage: "calendar")
                }
                .accessibilityIdentifier("management.schedule")
            }
        }
        .navigationTitle("面接管理")
    }
}

struct PastInterviewResultsView: View {
    var body: some View {
        EmptyStateView(
            title: "まだ面接の記録がありません",
            systemImage: "clock.arrow.circlepath",
            message: "完了した面接の質問と回答を、ここで振り返ることができます。"
        )
        .navigationTitle("過去の面接結果")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InterviewScheduleView: View {
    var body: some View {
        EmptyStateView(
            title: "面接の予定はありません",
            systemImage: "calendar",
            message: "これからの面接予定を確認する場所です。"
        )
        .navigationTitle("面接スケジュール")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        InterviewManagementView()
    }
}
