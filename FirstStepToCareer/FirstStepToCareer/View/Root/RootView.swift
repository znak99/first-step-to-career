//
//  RootView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct RootView: View {
    // MARK: - Variables
    @State private var isAppReady = false
    
    @EnvironmentObject private var navController: NavigationController
    
    // MARK: - UI
    var body: some View {
        NavigationStack(path: $navController.pagePath) {
            if isAppReady {
                ZStack {
                    CustomTabBarView()
                        .navigationDestination(for: Route.self) { page in
                            switch page {
                            case .interviewResumeView:
                                InterviewResumeView()
                            case .interviewAnalyticsView:
                                InterviewAnalyticsView()
                            case .interviewHistoryListView:
                                InterviewHistoryListView()
                            case .interviewPrepareView:
                                InterviewPrepareView()
                            case .signinView:
                                SigninView()
                            case .interviewView:
                                InterviewView()
                            default:
                                EmptyView()
                            }
                        }
                    KeyboardPrewarmView()
                        .frame(width: 0, height: 0)
                }
            } else {
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isAppReady = true
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationController())
}
