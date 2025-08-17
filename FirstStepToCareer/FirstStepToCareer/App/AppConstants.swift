//
//  AppConstants.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

// 앱의 전역에서 여러번 재사용되는 상수들 정의
enum AppConstants {
    // MARK: - Designs
    static let boxRadius: CGFloat = 16
    static let buttonRadius: CGFloat = 12
    
    // MARK: - SF Symbols
    static let chevronRight = "chevron.right"
    
    // MARK: - Util Fuctions
    // Date객체를 문자열 yyyy/MM/dd포맷으로 변환하는 함수
    // - Parameters:
    //   - date: Date객체
    // - Returns: yyyy/MM/dd포맷 문자열
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.string(from: date)
    }
}
