//
//  CompanyType.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

enum CompanyType: String, CaseIterable, Identifiable {
    // MARK: - Types
    case maker
    case trading
    case retail
    case finance
    case service
    case software
    case massmedia
    case government
    case none
    
    // MARK: - ID
    var id: String { rawValue }
    
    // MARK: - Label
    var label: String {
        switch self {
        case .maker:
            "メーカー"
        case .trading:
            "商社"
        case .retail:
            "小売"
        case .finance:
            "金融"
        case .service:
            "サービス"
        case .software:
            "ソフトウェア・通信"
        case .massmedia:
            "マスコミ"
        case .government:
            "官公庁・公社・団体"
        case .none:
            "企業区分を選択してください"
        }
    }
}
