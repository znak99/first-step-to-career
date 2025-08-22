//
//  CompanyType.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

// 모의면접을 위한 기업분야 리스트
enum CompanyType: String, Identifiable, CaseIterable {
    
    var id: String {
        return self.rawValue
    }
    
    case maker = "メーカー"
    case trading = "商社"
    case retail = "小売"
    case finance = "金融"
    case service = "サービス"
    case software = "ソフトウェア・通信"
    case massmedia = "マスコミ"
    case government = "官公庁・公社・団体"
    case none = "企業区分を選択してください"
}
