//
//  OverallMetrics.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

struct OverallMetrics: Codable, Sendable {
    let avgSpeechSpeedScore: Double
    let avgSilenceScore: Double
    let avgHeadDirectionScore: Double
    let avgGazeScore: Double
    let avgExpressionScore: Double

    let totalScore: Double
    let feedBack: String
}
