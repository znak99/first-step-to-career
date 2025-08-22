//
//  CareerType.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

// 모의면접을 위한 희망직종 리스트
enum CareerType: String, Identifiable, CaseIterable {
    
    var id: String {
        return self.rawValue
    }
    
    case sales = "営業"
    case office = "事務"
    case shop = "販売"
    case food = "飲食・フード"
    case service = "サービス"
    case event = "レジャー・娯楽"
    case education = "教育"
    case sports = "スポーツ"
    case beauty = "美容"
    case medical = "医療・介護"
    case driver = "ドライバー・配達"
    case manufacturing = "製造・工場・倉庫"
    case engineer = "IT・エンジニア"
    case creator = "クリエイティブ・編集"
    case technical = "専門職・技術"
    case construction = "建設"
    case none = "希望職種を選択してください"
}
