//
//  InterviewTabViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

@MainActor
final class InterviewTabViewModel: ObservableObject {
    // MARK: - Properties
    @Published var analyticsPreviewSpeechSpeedScore: Double = 0
    @Published var analyticsPreviewSilenceScore: Double = 0
    @Published var analyticsPreviewHeadDirectionScore: Double = 0
    @Published var analyticsPreviewGazeScore: Double = 0
    @Published var analyticsPreviewExpressionScore: Double = 0
    @Published var analyticsPreviewTotalScore: Double = 0
    
    @Published var isLoading: Bool = false
    @Published var isSignedin: Bool = false // temp
    @Published var isAppearing: Bool = true

    @Published var interviewInfo: InterviewInfo = .init()
    @Published var interviewResults: [InterviewResult]?
    @Published var highestScoreResult: InterviewResult?
    
    // MARK: - Actions
    func resumeButtonTapped(completion: @escaping () -> Void) {
        completion()
    }
    
    func analyticsButtonTapped(completion: @escaping () -> Void) {
        completion()
    }
    
    func historyButtonTapped(completion: @escaping () -> Void) {
        completion()
    }
    
    func signinBUttonTapped(completion: @escaping () -> Void) {
        completion()
    }
    
    func startButtonTapped(completion: @escaping () -> Void) {
        completion()
    }
    
    func appAppeared() {
        // TODO: - 데이터 있는지 확인
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAppearing = false
        }
    }

    // MARK: - Logic
    func loadInterviewData() {
        // TODO: - 로그인 비동기처리 구현하면 Shimmer 처리 수정하기
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let results = InterviewMockDataGenerator.makeInterviewResults()
            self.isLoading = false
            self.interviewResults = results
            self.setHighestScoringResult()
            self.setPreviewScores()
            print("Generated \(results.count) InterviewResults")
        }
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
