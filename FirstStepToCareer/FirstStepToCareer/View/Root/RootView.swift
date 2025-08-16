//
//  RootView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct RootView: View {
    // MARK: - Variables
    @State private var isAppReady = true
    
    @EnvironmentObject private var navController: NavigationController
    
    // MARK: - UI
    var body: some View {
        NavigationStack(path: $navController.pagePath) {
            if isAppReady {
                CustomTabBarView()
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
