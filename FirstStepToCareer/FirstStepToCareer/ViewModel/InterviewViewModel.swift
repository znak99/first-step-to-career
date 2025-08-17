//
//  InterviewViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

class InterviewViewModel: ObservableObject {
    @Published var mockInterviewInfo: MockInterviewInfo = .init()
    @Published var bestHistory: MockInterviewResult?
}
