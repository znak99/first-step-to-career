import SwiftUI

struct MainTabView: View {
    @State private var questionCount = InterviewConfiguration.defaultQuestionCount
    @State private var movementScoringEnabled = true

    var body: some View {
        TabView {
            NavigationStack {
                MockInterviewView(questionCount: questionCount)
            }
            .tabItem {
                Label("模擬面接", systemImage: "bubble.left.and.bubble.right")
            }

            NavigationStack {
                InterviewManagementView()
            }
            .tabItem {
                Label("面接管理", systemImage: "calendar")
            }

            NavigationStack {
                InterviewAnalysisView()
            }
            .tabItem {
                Label("面接分析", systemImage: "chart.bar")
            }

            NavigationStack {
                SettingsView(questionCount: $questionCount, movementScoringEnabled: $movementScoringEnabled)
            }
            .tabItem {
                Label("メニュー", systemImage: "line.3.horizontal")
            }
        }
    }
}

#Preview {
    MainTabView()
        .tint(.teal)
}
