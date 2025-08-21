//
//  InterviewPreviewAnalyzer.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation

enum InterviewPreviewAnalyzer {
    static func getHighestScoreResult(in results: [InterviewResult]?) -> InterviewResult? {
        guard let results, !results.isEmpty else { return nil }
        return results.max(by: { $0.overall.totalScore < $1.overall.totalScore })
    }
    
    static func getAnalyticsSpeechSpeedAvgScore(results: [InterviewResult]?) -> Double {
        guard let results, !results.isEmpty else { return 0.0 }
        
        var score: Double = 0.0
        results.forEach { result in
            score += result.overall.avgSpeechSpeedScore
        }
        
        return score / Double(results.count)
    }
    
    static func getAnalyticsSilenceAvgScore(results: [InterviewResult]?) -> Double {
        guard let results, !results.isEmpty else { return 0.0 }
        
        var score: Double = 0.0
        results.forEach { result in
            score += result.overall.avgSilenceScore
        }
        
        return score / Double(results.count)
    }
    
    static func getAnalyticsHeadDirectionAvgScore(results: [InterviewResult]?) -> Double {
        guard let results, !results.isEmpty else { return 0.0 }
        
        var score: Double = 0.0
        results.forEach { result in
            score += result.overall.avgHeadDirectionScore
        }
        
        return score / Double(results.count)
    }
    
    static func getAnalyticsGazeAvgScore(results: [InterviewResult]?) -> Double {
        guard let results, !results.isEmpty else { return 0.0 }
        
        var score: Double = 0.0
        results.forEach { result in
            score += result.overall.avgGazeScore
        }
        
        return score / Double(results.count)
    }
    
    static func getAnalyticsExpressionAvgScore(results: [InterviewResult]?) -> Double {
        guard let results, !results.isEmpty else { return 0.0 }
        
        var score: Double = 0.0
        results.forEach { result in
            score += result.overall.totalScore
        }
        
        return score / Double(results.count)
    }
    
    static func getAnalyticsTotalAvgScore(results: [InterviewResult]?) -> Double {
        guard let results, !results.isEmpty else { return 0.0 }
        
        var score: Double = 0.0
        results.forEach { result in
            score += result.overall.avgSpeechSpeedScore
        }
        
        return score / Double(results.count)
    }
}
