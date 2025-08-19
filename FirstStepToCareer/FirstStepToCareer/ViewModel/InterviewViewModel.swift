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
    @Published var interviewResults: [InterviewResult]?
    @Published var highestScoreResult: InterviewResult?
    @Published var a: Double = 0.0
    @Published var b: Double = 0.0
    @Published var c: Double = 0.0
    @Published var d: Double = 0.0
    @Published var e: Double = 0.0
    @Published var f: Double = 0.0
    
    // MARK: - Functions
    func forTestMakeDummyData() {
        // MARK: - 실행 예시
        interviewResults = InterviewMockDataGenerator.makeInterviewResults()
        // 필요시 확인
        print("Generated \(interviewResults!.count) InterviewResults")
        if let first = interviewResults!.first {
            print("First startedAt:", first.startedAt)
            print("First createdAt:", first.createdAt?.dateValue() as Any)
            print("First updatedAt:", first.updatedAt?.dateValue() as Any)
            print("First turns:", first.turns.count)
        }
        
        highestScoreResult = highestScoringResult(in: interviewResults)
        avgScores(in: interviewResults)
    }
    
    func highestScoringResult(in results: [InterviewResult]?) -> InterviewResult? {
        guard let results, !results.isEmpty else { return nil }

        return results.max { lhs, rhs in
            (lhs.overall.totalScore) < (rhs.overall.totalScore)
        }
    }
    
    // TODO: - 잘 수정하기
    func avgScores(in results: [InterviewResult]?) {
        guard let results, !results.isEmpty else { return }
        
        var avgA: Double = 0
        var avgB: Double = 0
        var avgC: Double = 0
        var avgD: Double = 0
        var avgE: Double = 0
        var avgF: Double = 0
        
        for result in results {
            avgA += result.overall.avgSpeechSpeedScore
            avgB += result.overall.avgSilenceScore
            avgC += result.overall.avgHeadDirectionScore
            avgD += result.overall.avgGazeScore
            avgE += result.overall.avgExpressionScore
            avgF += result.overall.totalScore
        }
        
        a = avgA / Double(results.count)
        b = avgB / Double(results.count)
        c = avgC / Double(results.count)
        d = avgD / Double(results.count)
        e = avgE / Double(results.count)
        f = avgF / Double(results.count)
    }
}
