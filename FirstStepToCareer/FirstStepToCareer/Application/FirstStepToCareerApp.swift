//
//  FirstStepToCareerApp.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

@main
struct FirstStepToCareerApp: App {
    // MARK: - Properties
    @StateObject var nc: NavigationController = .init()
    @StateObject var interviewEngine: InterviewEngine = .init()
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(nc)
                .environmentObject(interviewEngine)
        }
    }
}
