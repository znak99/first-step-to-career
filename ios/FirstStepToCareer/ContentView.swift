//
//  ContentView.swift
//  FirstStepToCareer
//
//  Created by 홍승우 on 2026/11/05.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = LaunchViewModel()

    var body: some View {
        Group {
            switch viewModel.phase {
            case .splash:
                SplashView()
                    .task {
                        await viewModel.showSplash()
                    }
            case .onboarding:
                OnboardingView {
                    viewModel.start()
                }
            case .main:
                MainTabView()
            }
        }
        .tint(.teal)
    }
}

#Preview {
    ContentView()
}
