//
//  QuestionGenerating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

protocol QuestionGenerating: Sendable {
    func generateNextQuestion(context: InterviewContext) async throws -> Question
    func prefetch(_ n: Int, context: InterviewContext) async
}
