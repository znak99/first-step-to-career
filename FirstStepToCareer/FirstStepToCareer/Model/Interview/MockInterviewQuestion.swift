//
//  MockInterviewQuestion.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

// 모의면접 결과 객체에 배열로 저장될 객체
// 질문 + 답변 한쌍으로 저장
struct MockInterviewQuestion: Identifiable, Codable {
    let id: UUID
}
