//
//  EmotionResult.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

struct EmotionResult: Sendable {
    enum Category: String, Sendable { case positive, neutral, negative, uncertain }
    var category: Category
    var confidence: Double
}
