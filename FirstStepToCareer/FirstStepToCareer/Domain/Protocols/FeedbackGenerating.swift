//
//  FeedbackGenerating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

protocol FeedbackGenerating: Sendable {
    func generateFeedback(log: String, scores: InterviewScores) async throws -> InterviewFeedback
}
