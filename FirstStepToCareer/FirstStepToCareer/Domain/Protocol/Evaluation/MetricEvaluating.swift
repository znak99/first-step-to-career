//
//  MetricEvaluating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

protocol MetricEvaluating: Sendable {
    var policyVersion: String { get }
    func evaluate(session: SessionMetrics) async -> InterviewScores
}
