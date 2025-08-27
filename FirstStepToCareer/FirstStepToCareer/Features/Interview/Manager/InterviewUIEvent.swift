//
//  InterviewUIEvent.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation

enum InterviewUIEvent: Sendable {
    case toast(String)
    case alert(title: String, message: String)
    case hapticSuccess
}
