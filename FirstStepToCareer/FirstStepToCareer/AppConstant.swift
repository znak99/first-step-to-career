//
//  AppConstants.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

enum AppConstant {
    // MARK: - Designs
    enum Radius {
        @available(*, deprecated, message: "Use DesignSystem.Radius.section instead.")
        static let section: CGFloat = 16
        
        @available(*, deprecated, message: "Use DesignSystem.Radius.box instead.")
        static let box: CGFloat = 12
        
        @available(*, deprecated, message: "Use DesignSystem.Radius.field instead.")
        static let field: CGFloat = 8
    }
    
    // MARK: - Util Functions
    @available(*, deprecated, message: "Use DateFormatter extension or DateUtility instead.")
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}

// MARK: - SFSymbols
enum SFSymbolsIcon {
    @available(*, deprecated, message: "Use Image(systemName:) directly or DesignSystem.Icon instead.")
    static let chevronLeft = "chevron.left"
    
    @available(*, deprecated, message: "Use Image(systemName:) directly or DesignSystem.Icon instead.")
    static let chevronRight = "chevron.right"
    
    @available(*, deprecated, message: "Use Image(systemName:) directly or DesignSystem.Icon instead.")
    static let graduationcapFill = "graduationcap.fill"
    
    @available(*, deprecated, message: "Use Image(systemName:) directly or DesignSystem.Icon instead.")
    static let suitcaseFill = "suitcase.fill"
}

// MARK: - Global
enum GlobalIcon {
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let appLogoWhite = "Icon/Logo/White"
    
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let appLogoPrimary = "Icon/Logo/Primary"
}

// MARK: - InterviewTab
enum InterviewTabIcon {
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let header = "Icon/InterviewTab/Header"
    
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let resume = "Icon/InterviewTab/Resume"
    
    enum Analytics {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let header = "Icon/InterviewTab/Analytics/Header"
        
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let noData = "Icon/InterviewTab/Analytics/NoData"
    }
    
    enum History {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let header = "Icon/InterviewTab/History/Header"
        
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let signin = "Icon/InterviewTab/History/Signin"
        
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let noData = "Icon/InterviewTab/History/NoData"
        
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let unauthenticated = "Icon/InterviewTab/History/Unauthenticated"
    }
    
    enum Interview {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let header = "Icon/InterviewTab/Interview/Header"
        
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let nav = "Icon/InterviewTab/Interview/Nav"
    }
}

// MARK: - InterviewPrepare
enum InterviewPrepareIcon {
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let headerCaption = "Icon/InterviewPrepare/HeaderCaption"
    
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let nav = "Icon/InterviewPrepare/Nav"
    
    enum CompanyName {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let header = "Icon/InterviewPrepare/CompanyName/Header"
    }
    
    enum RecruitType {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let headerL = "Icon/InterviewPrepare/RecruitType/HeaderL"
        
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let headerR = "Icon/InterviewPrepare/RecruitType/HeaderR"
    }
    
    enum CompanyType {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let header = "Icon/InterviewPrepare/CompanyType/Header"
    }
    
    enum CareerType {
        @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
        static let header = "Icon/InterviewPrepare/CareerType/Header"
    }
}

// MARK: - ScheduleTab
enum ScheduleTabIcon {
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let header = "Icon/ScheduleTab/Header"
}

// MARK: - ManagementTab
enum ManagementTabIcon {
    @available(*, deprecated, message: "Use Asset Catalog (xcassets) or DesignSystem.Icon instead.")
    static let header = "Icon/ManagementTab/Header"
}

extension Color {
    // MARK: - App Colors
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appBackground = Color(hex: "#F2F2F2")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appPrimary = Color(hex: "#4A6CF7")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appMainGradientStart = Color(hex: "#6E89FA")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appMainGradientEnd = Color(hex: "#2C4FDD")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appGray = Color(hex: "#959595")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appGreen = Color(hex: "#66BB6A")
    
    // MARK: - Tab bar
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appTabBarBackground = Color(hex: "#FEFEFE")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appTabBarGray = Color(hex: "#BFBFBF")
    
    // MARK: - Interview Analytics
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsSpeechSpeedGradientStart = Color(hex: "#E53935")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsSpeechSpeedGradientEnd = Color(hex: "#EF5350")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsSilenceGradientStart = Color(hex: "#43A047")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsSilenceGradientEnd = Color(hex: "#4CAF50")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsHeadDirectionGradientStart = Color(hex: "#FB8C00")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsHeadDirectionGradientEnd = Color(hex: "#FF9800")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsGazeGradientStart = Color(hex: "#1E88E5")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsGazeGradientEnd = Color(hex: "#42A5F5")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsExpressionGradientStart = Color(hex: "#8E24AA")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsExpressionGradientEnd = Color(hex: "#AB47BC")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsTotalGradientStart = Color(hex: "#212121")
    
    @available(*, deprecated, message: "Use ColorAssets or DesignSystem.Color instead.")
    static let appAnalyticsTotalGradientEnd = Color(hex: "#424242")
}
