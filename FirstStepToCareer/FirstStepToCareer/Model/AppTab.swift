//
//  AppTab.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

enum AppTab {
    case interview, companyList, schedule, analysis, settings
    
    var label: String {
        switch self {
        case .interview:
            return "面接"
        case .companyList:
            return "選考"
        case .schedule:
            return "日程"
        case .analysis:
            return "分析"
        case .settings:
            return "設定"
        }
    }
    
    var icon: String {
        switch self {
        case .interview:
            return "person.crop.rectangle"
        case .companyList:
            return "list.bullet.rectangle"
        case .schedule:
            return "calendar"
        case .analysis:
            return "chart.bar.xaxis"
        case .settings:
            return "line.3.horizontal"
        }
    }
}
