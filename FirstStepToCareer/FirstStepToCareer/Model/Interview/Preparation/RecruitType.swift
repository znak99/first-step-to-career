//
//  RecruitType.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

// 모의면접을 위한 신입/경력 정보
enum RecruitType {
    case new
    case old
    
    var label: String {
        switch self {
        case .new:
            return "新卒"
        case .old:
            return "中途"
        }
    }
    
    var icon: String {
        switch self {
        case .new:
            return "graduationcap.fill"
        case .old:
            return "suitcase.fill"
        }
    }
}
