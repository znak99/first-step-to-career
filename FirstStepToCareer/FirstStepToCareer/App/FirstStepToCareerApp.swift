//
//  FirstStepToCareerApp.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

@main
struct FirstStepToCareerApp: App {
    // MARK: - Variables
    @StateObject var navController = NavigationController()
    
    // MARK: - UI
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navController)
        }
    }
}
