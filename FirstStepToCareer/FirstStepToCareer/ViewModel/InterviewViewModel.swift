//
//  InterviewViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

class InterviewViewModel: ObservableObject {
    // MARK: - Variables
    @Published var interviewInfo: InterviewInfo = .init()
    @Published var interviewResults: [InterviewResult]?
    @Published var highestScoreResult: InterviewResult?
    @Published var graphData: [AnalyticsPreviewGraph] = []
    
    // MARK: - Functions
    func highestScoringResult(in results: [InterviewResult]?) -> InterviewResult? {
        guard let results, !results.isEmpty else { return nil }

        return results.max { lhs, rhs in
            (lhs.overall.totalScore) < (rhs.overall.totalScore)
        }
    }
    
    func mapGraphData(in results: [InterviewResult]?) {
        guard let results, !results.isEmpty else { return }
        var previewData: [AnalyticsPreviewGraph] = []
        
        let labels: [String] = ["速度", "沈黙", "動き", "視線", "表情", "総合"]
        let gradientStartColors: [Color] = [
            .appAnalysisRed, .appAnalysisGreen, .appAnalysisOrange,
            .appAnalysisBlue, .appAnalysisPurple, .appAnalysisBlack
        ]
        let gradientEndColors: [Color] = [
            .appAnalysisRed1, .appAnalysisGreen1, .appAnalysisOrange1,
            .appAnalysisBlue1, .appAnalysisPurple1, .appAnalysisBlack1
        ]
        
        var scores: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        for result in results {
            scores[0] += result.overall.avgSpeechSpeedScore
            scores[1] += result.overall.avgSilenceScore
            scores[2] += result.overall.avgHeadDirectionScore
            scores[3] += result.overall.avgGazeScore
            scores[4] += result.overall.avgExpressionScore
            scores[5] += result.overall.totalScore
        }
        
        let avgs = scores.map { value in
            value / Double(results.count)
        }
        
        for i in 0..<6 {
            let data = AnalyticsPreviewGraph(
                label: labels[i],
                gradientStart: gradientStartColors[i],
                gradientEnd: gradientEndColors[i],
                score: avgs[i]
            )
            
            previewData.append(data)
        }
        
        graphData = previewData
    }
    
    func forTestMakeDummyData() {
        interviewResults = InterviewMockDataGenerator.makeInterviewResults()
        print("Generated \(interviewResults!.count) InterviewResults")
        if let first = interviewResults!.first {
            print("First startedAt:", first.startedAt)
            print("First createdAt:", first.createdAt?.dateValue() as Any)
            print("First updatedAt:", first.updatedAt?.dateValue() as Any)
            print("First turns:", first.turns.count)
        }
        
        highestScoreResult = highestScoringResult(in: interviewResults)
        mapGraphData(in: interviewResults)
    }
}
