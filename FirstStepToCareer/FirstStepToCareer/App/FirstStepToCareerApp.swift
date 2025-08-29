//
//  FirstStepToCareerApp.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@main
struct FirstStepToCareerApp: App {
    // MARK: - Properties
    @StateObject var nc: NavigationController = .init()
    @StateObject var interviewOrchestrator: InterviewOrchestrator = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ServiceTestView()
//            RootView()
//                .environmentObject(nc)
//                .environmentObject(interviewOrchestrator)
//                .onAppear {
//                    let settings = FirestoreSettings()
//                    settings.cacheSettings = PersistentCacheSettings()
//                    Firestore.firestore().settings = settings
//                }
        }
    }
}
