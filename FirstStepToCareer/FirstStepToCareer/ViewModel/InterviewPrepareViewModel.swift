//
//  InterviewPrepareViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/22.
//

import Foundation

@MainActor
final class InterviewPrepareViewModel: ObservableObject {
    @Published var interviewInfo: InterviewInfo = .init()
    @Published var sectionHeaderLottie: String?
}
