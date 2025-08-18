//
//  AppTab.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

// Custom Tab Bar 관리용 enum
enum AppTab {
    case interview, schedule, management, settings
    
    var label: String {
        switch self {
        case .interview:
            return "面接"
        case .schedule:
            return "日程"
        case .management:
            return "選考"
        case .settings:
            return "設定"
        }
    }
    
    var icon: String {
        switch self {
        case .interview:
            return "person.crop.rectangle"
        case .schedule:
            return "calendar"
        case .management:
            return "list.bullet.rectangle"
        case .settings:
            return "line.3.horizontal"
        }
    }
}
