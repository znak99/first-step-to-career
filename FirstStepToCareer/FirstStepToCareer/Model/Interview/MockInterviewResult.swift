//
//  MockInterviewResult.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

// 모의면접 종료후의 결과 객체
// TODO: recruitType, companyType, careerType 객체 쓸지 문자열 쓸지 확인하기
struct MockInterviewResult {
    let id: UUID
    let userId: UUID
    
    let companyName: String
    let recruitType: String
    let companyType: String
    let careerType: String
    
    let questions: [MockInterviewQuestion]
    
    let score: String
    
    let createdAt: Date
    let updatedAt: Date
}
