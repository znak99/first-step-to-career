//
//  AppConstants.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import FirebaseFirestore

// 앱의 전역에서 여러번 재사용되는 상수들 정의
enum AppConstants {
    // MARK: - Designs
    static let sectionRadius: CGFloat = 16
    static let fieldRadius: CGFloat = 8
    static let boxRadius: CGFloat = 12
    
    // MARK: - SF Symbols
    static let chevronLeft = "chevron.left"
    static let chevronRight = "chevron.right"
    
    // MARK: - App Icons
    static let interviewTabHeaderIcon = "InterviewTabHeaderIcon"
    static let interviewTabAnalysisIcon = "InterviewTabChart"
    static let interviewTabHistoryIcon = "InterviewTabHistory"
    static let interviewTabWebCamIcon = "InterviewTabWebCam"
    static let interviewTabFocus = "InterviewTabFocus"
    static let interviewTabSignIn = "InterviewTabSignIn"
    static let interviewTabNoData = "InterviewTabNoData"
    static let interviewTabUnauthorized = "InterviewTabUnauthorized"
    static let scheduleTabHeaderIcon = "ScheduleTabHeaderIcon"
    static let managementTabHeaderIcon = "ManagementTabHeaderIcon"
    
    // MARK: - Util Fuctions
    // Date객체를 문자열 yyyy/MM/dd포맷으로 변환하는 함수
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.string(from: date)
    }
}
