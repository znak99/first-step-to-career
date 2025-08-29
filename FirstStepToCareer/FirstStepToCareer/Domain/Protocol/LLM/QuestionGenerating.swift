//
//  QuestionGenerating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

protocol QuestionGenerating: Sendable {
    /// 다음 질문 1개 생성/반환. 내부 큐가 비면 on-demand로 생성
    func generateNextQuestion(context: InterviewContext) async throws -> Question
    /// 미리 n개 생성하여 내부 큐에 적재(네트워크/LLM이면 프리페치 의미)
    func prefetch(_ n: Int, context: InterviewContext) async
}
