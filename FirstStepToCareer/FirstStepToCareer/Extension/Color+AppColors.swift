//
//  Color+AppColors.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

extension Color {
    // 색깔을 HEX로 초기화하는 로직
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    // App
    static let appBackground = Color(hex: "#F2F2F2")
    static let appPrimary = Color(hex: "#4A6CF7")
    static let appMainGradientStart = Color(hex: "#6E89FA")
    static let appMainGradientEnd = Color(hex: "#2C4FDD")
    static let appGray = Color(hex: "#959595")
    
    // Tab bar
    static let appTabBarBackground = Color(hex: "#FEFEFE")
    static let appTabBarGray = Color(hex: "#BFBFBF")
    
    // Interview Analytics
    static let appAnalyticsSpeechSpeedGradientStart = Color(hex: "#E53935")
    static let appAnalyticsSpeechSpeedGradientEnd = Color(hex: "#EF5350")
    static let appAnalyticsSilenceGradientStart = Color(hex: "#43A047")
    static let appAnalyticsSilenceGradientEnd = Color(hex: "#4CAF50")
    static let appAnalyticsHeadDirectionGradientStart = Color(hex: "#FB8C00")
    static let appAnalyticsHeadDirectionGradientEnd = Color(hex: "#FF9800")
    static let appAnalyticsGazeGradientStart = Color(hex: "#1E88E5")
    static let appAnalyticsGazeGradientEnd = Color(hex: "#42A5F5")
    static let appAnalyticsExpressionGradientStart = Color(hex: "#8E24AA")
    static let appAnalyticsExpressionGradientEnd = Color(hex: "#AB47BC")
    static let appAnalyticsTotalGradientStart = Color(hex: "#212121")
    static let appAnalyticsTotalGradientEnd = Color(hex: "#424242")
}
