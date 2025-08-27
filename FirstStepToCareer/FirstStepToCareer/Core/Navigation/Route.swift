//
//  Route.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

enum Route: Hashable {
    // MARK: - Interview
    case resumeView
    case analyticsView
    case historyListView
    case historyDetailView(id: Int)
    case interviewInfoFormView
    case interviewView
    case interviewResultView
    
    // MARK: - Schedule
    case scheduleAddView
    case scheduleEditView(id: Int)
    case scheduleDetailView(id: Int)
    
    // MARK: - Process
    case processAddView
    case processEditView(id: Int)
    case processDetailView(id: Int)
    
    // MARK: - Settings
    
    // MARK: - Auth
    case signinView
    case signupView
}
