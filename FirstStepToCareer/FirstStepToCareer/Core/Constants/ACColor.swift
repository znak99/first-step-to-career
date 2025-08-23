//
//  ACColor.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

enum ACColor {
    // MARK: - Brand
    enum Brand {
        static let backgroundPrimary = BaseColor.gray50
        static let Primary = BaseColor.indigo500
        static let GradientStart = BaseColor.indigo400
        static let GradientEnd = BaseColor.indigo700
    }
    
    // MARK: - Font
    enum Font {
        static let black = BaseColor.black
        static let white = BaseColor.white
        static let gray = BaseColor.gray500
    }

    // MARK: - Status
    enum Status {
        static let error = BaseColor.red600
        static let warning = BaseColor.amber500
        static let info = BaseColor.blue600
        static let success = BaseColor.green500
    }
    
    // MARK: - Tab bar
    enum TabBar {
        static let active = BaseColor.indigo500
        static let inactive = BaseColor.gray400
        static let background = BaseColor.gray0
    }
    
    // MARK: - Analytics
    enum Analytics {
        static let speechSpeed = BaseColor.red600
        static let silence = BaseColor.green600
        static let headDirection = BaseColor.orange600
        static let gaze = BaseColor.blue600
        static let expression = BaseColor.purple600
        static let total = BaseColor.gray900
    }
}

private enum BaseColor {
    // MARK: - Neutrals
    static let gray0 = Color(hex: "#FEFEFE")
    static let gray50 = Color(hex: "#F2F2F2")
    static let gray400 = Color(hex: "#BFBFBF")
    static let gray500 = Color(hex: "#959595")
    static let gray700 = Color(hex: "#424242")
    static let gray900 = Color(hex: "#212121")
    static let black = Color(hex: "#000000")
    static let white = Color(hex: "#FFFFFF")

    // MARK: - Brand / Primary Family
    static let indigo500 = Color(hex: "#4A6CF7")
    static let indigo400 = Color(hex: "#6E89FA")
    static let indigo700 = Color(hex: "#2C4FDD")

    // MARK: - Accent
    static let red600 = Color(hex: "#E53935")
    static let orange600 = Color(hex: "#FB8C00")
    static let amber500 = Color(hex: "#F59E0B")
    static let green500 = Color(hex: "#66BB6A")
    static let green600 = Color(hex: "#43A047")
    static let blue600 = Color(hex: "#1E88E5")
    static let purple600 = Color(hex: "#8E24AA")
}
