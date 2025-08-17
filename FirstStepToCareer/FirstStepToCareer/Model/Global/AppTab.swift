//
//  AppTab.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

// Custom Tab Bar 관리용 enum
enum AppTab {
    case interview, analysis, schedule, companyList, settings
    
    var label: String {
        switch self {
        case .interview:
            return "面接"
        case .analysis:
            return "分析"
        case .schedule:
            return "日程"
        case .companyList:
            return "選考"
        case .settings:
            return "設定"
        }
    }
    
    var icon: String {
        switch self {
        case .interview:
            return "person.crop.rectangle"
        case .analysis:
            return "chart.bar.xaxis"
        case .schedule:
            return "calendar"
        case .companyList:
            return "list.bullet.rectangle"
        case .settings:
            return "line.3.horizontal"
        }
    }
}
