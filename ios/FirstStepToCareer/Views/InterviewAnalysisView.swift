import SwiftUI

struct InterviewAnalysisView: View {
    var body: some View {
        EmptyStateView(
            title: "振り返りは、ここから。",
            systemImage: "chart.bar",
            message: "面接を重ねながら、自分の受け答えを振り返っていきましょう。"
        )
        .navigationTitle("面接分析")
    }
}

#Preview {
    NavigationStack {
        InterviewAnalysisView()
    }
}
