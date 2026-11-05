import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.walk.circle.fill")
                .font(.system(size: 76))
                .foregroundStyle(.teal)
                .accessibilityHidden(true)

            Text("就活一歩")
                .font(.largeTitle.bold())

            Text("あなたのペースで、次の一歩へ。")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .accessibilityIdentifier("launch.splash")
    }
}

struct OnboardingView: View {
    let onStart: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "figure.walk.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.teal)
                        .accessibilityHidden(true)

                    Text("面接に、自分らしい\n一歩を。")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)

                    Text("練習も、振り返りも、これからの予定も。\n就活一歩で、少しずつ準備を進めましょう。")
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 24) {
                    feature("面接を練習する", detail: "応募先や職種に合わせて、受け答えを練習。", icon: "bubble.left.and.bubble.right")
                    feature("面接を管理する", detail: "過去の面接結果や、これからの予定を確認。", icon: "calendar")
                    feature("自分を振り返る", detail: "面接の振り返りを、次の一歩につなげる。", icon: "chart.bar")
                }
            }
            .padding(28)
            .frame(maxWidth: 600, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            Button("はじめる", action: onStart)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 36)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityIdentifier("onboarding.start")
                .padding(24)
                .background(.bar)
        }
    }

    private func feature(_ title: String, detail: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.teal)
                .frame(width: 32)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview("スプラッシュ") {
    SplashView()
}

#Preview("オンボーディング") {
    OnboardingView(onStart: {})
        .tint(.teal)
}
