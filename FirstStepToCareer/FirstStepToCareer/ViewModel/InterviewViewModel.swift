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
    }
}
