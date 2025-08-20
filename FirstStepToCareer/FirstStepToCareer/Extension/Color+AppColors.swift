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
    static let appPrimaryGradient01 = Color(hex: "#1EA9FF")
    static let appPrimaryGradient02 = Color(hex: "#0072B9")
    static let appBackground = Color(hex: "#F2F2F2")
    static let appAccentColor = Color(hex: "#1D9BE9")
    static let appGrayFont = Color(hex: "#959595")
    
    // Tab bar
    static let appTabBarBackground = Color(hex: "#FEFEFE")
    static let appTabBarAccent = Color(hex: "#1A8ED6")
    static let appTabBarGray = Color(hex: "#BFBFBF")
    
    // Interview
    static let appInterviewGradient = Color(hex: "#B8E4FF")
}
