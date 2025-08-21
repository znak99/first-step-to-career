//
//  InterviewViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

@MainActor
class InterviewViewModel: ObservableObject {
    // MARK: - Preview Scores
    @Published var analyticsPreviewSpeechSpeedScore: Double = 0
    @Published var analyticsPreviewSilenceScore: Double = 0
    @Published var analyticsPreviewHeadDirectionScore: Double = 0
    @Published var analyticsPreviewGazeScore: Double = 0
    @Published var analyticsPreviewExpressionScore: Double = 0
    @Published var analyticsPreviewTotalScore: Double = 0
    
    // MARK: - Shimmer
    @Published var isLoading = true
    @Published var isAppearing = true

    // MARK: - Data
    @Published var interviewInfo: InterviewInfo = .init()
    @Published var interviewResults: [InterviewResult]?
    @Published var highestScoreResult: InterviewResult?

    // MARK: - Logic
    func loadInterviewData() {
        // TODO: - 로그인 비동기처리 구현하면 Shimmer 처리 수정하기
        isLoading = true
        let results = InterviewMockDataGenerator.makeInterviewResults()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.isLoading = false
                self.interviewResults = results
                self.setHighestScoringResult()
                self.setPreviewScores()
            }
        }
        
        print("Generated \(results.count) InterviewResults")
    }
    
    func setHighestScoringResult() {
        highestScoreResult = InterviewPreviewAnalyzer.getHighestScoreResult(in: interviewResults)
    }
    
    func setPreviewScores() {
        analyticsPreviewSpeechSpeedScore = InterviewPreviewAnalyzer
            .getAnalyticsSpeechSpeedAvgScore(results: interviewResults)
        analyticsPreviewSilenceScore = InterviewPreviewAnalyzer
            .getAnalyticsSilenceAvgScore(results: interviewResults)
        analyticsPreviewHeadDirectionScore = InterviewPreviewAnalyzer
            .getAnalyticsHeadDirectionAvgScore(results: interviewResults)
        analyticsPreviewGazeScore = InterviewPreviewAnalyzer
            .getAnalyticsGazeAvgScore(results: interviewResults)
        analyticsPreviewExpressionScore = InterviewPreviewAnalyzer
            .getAnalyticsExpressionAvgScore(results: interviewResults)
        analyticsPreviewTotalScore = InterviewPreviewAnalyzer
            .getAnalyticsTotalAvgScore(results: interviewResults)
    }
}
