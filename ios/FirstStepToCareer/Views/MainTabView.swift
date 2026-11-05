import SwiftUI

struct MainTabView: View {
    @State private var settings = SettingsViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                MockInterviewView(questionCount: settings.questionCount)
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
                SettingsView(viewModel: settings)
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
