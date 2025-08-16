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
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
    
    static let appPrimaryGradient01 = Color(hex: "#1EA9FF")
    static let appPrimaryGradient02 = Color(hex: "#1670A8")
}
