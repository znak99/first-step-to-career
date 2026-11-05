//
//  ContentView.swift
//  FirstStepToCareer
//
//  Created by 홍승우 on 2026/11/05.
//

import SwiftUI

struct ContentView: View {
    @State private var phase: LaunchPhase = .splash

    var body: some View {
        Group {
            switch phase {
            case .splash:
                SplashView()
                    .task {
                        do {
                            try await Task.sleep(for: .milliseconds(800))
                            phase = .onboarding
                        } catch {
                            return
                        }
                    }
            case .onboarding:
                OnboardingView {
                    phase = .main
                }
            case .main:
                MainTabView()
            }
        }
        .tint(.teal)
    }

    private enum LaunchPhase {
        case splash
        case onboarding
        case main
    }
}

#Preview {
    ContentView()
}
