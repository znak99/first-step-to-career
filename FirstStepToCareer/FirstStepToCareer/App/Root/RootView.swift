//
//  RootView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct RootView: View {
    // MARK: - Properties
    @StateObject private var vm: RootViewModel = .init()
    @EnvironmentObject private var nc: NavigationController
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $nc.path) {
            if vm.isAppReady {
                ZStack {
                    AppTabBarView()
                        .navigationDestination(for: Route.self) { page in
                            switch page {
                            case .resumeView:
                                ResumeView()
                            case .analyticsView:
                                AnalyticsView()
                            case .historyListView:
                                HistoryListView()
                            case .interviewInfoFormView:
                                InterviewInfoFormView()
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
                if !vm.isAppReady {
                    vm.isAppReady.toggle()
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationController())
}
