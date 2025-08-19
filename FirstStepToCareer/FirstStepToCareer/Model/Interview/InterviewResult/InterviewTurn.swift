//
//  InterviewTurn.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

import Foundation

struct InterviewTurn: Identifiable, Codable {
    
    let id: String
    
    // 질문
    let questionId: String
    let questionText: String

    // 답변
    let answerText: String?
    let answerDurationSec: Double
    let startedAt: Date
    let endedAt: Date

    // 평가
    let speechSpeed: SpeechSpeedMetric?
    let silence: SilenceMetric?
    let headDirection: HeadDirectionMetric?
    let gaze: GazeMetric?
    let expression: ExpressionMetric?
}
