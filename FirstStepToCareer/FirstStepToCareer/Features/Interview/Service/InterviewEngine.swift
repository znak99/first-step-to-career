//
//  InterviewEngine.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

actor InterviewEngine: ObservableObject {
    // MARK: - Properties
    private(set) var interviewInfo: InterviewInfo?
    
    // MARK: - Actions
    func setInterviewInfo(info: InterviewInfo) {
        interviewInfo = info
    }
}
