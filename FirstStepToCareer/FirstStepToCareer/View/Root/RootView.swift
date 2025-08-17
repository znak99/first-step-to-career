//
//  RootView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

// 앱 화면 시작점 (스플래쉬 화면과 메인 화면 스위칭)
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
