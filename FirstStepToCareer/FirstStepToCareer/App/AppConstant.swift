//
//  AppConstants.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

// 앱의 전역에서 여러번 재사용되는 상수들 정의
enum AppConstant {
    // MARK: - Designs
    enum Radius {
        static let section: CGFloat = 16
        static let box: CGFloat = 12
        static let field: CGFloat = 8
    }
    
    // MARK: - Util Fuctions
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return formatter.string(from: date)
    }
}
