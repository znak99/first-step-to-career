//
//  FeedbackGenerating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

protocol FeedbackGenerating: Sendable {
    /// 면접 종료 후 대화 로그(질문/답변 텍스트)를 입력 받아 피드백 문자열을 생성
    /// - Parameters:
    ///   - log: Q&A 전체 텍스트 (한 번에 전달)
    ///   - context: 선택. 회사명/직무 등 피드백 문맥 강화를 위해 사용
    func generateFeedback(log: String, context: InterviewContext?) async throws -> InterviewFeedback
}
