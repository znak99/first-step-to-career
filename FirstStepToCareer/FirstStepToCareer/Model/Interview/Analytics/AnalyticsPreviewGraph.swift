//
//  AnalyticsPreviewGraph.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/20.
//

import SwiftUI

struct AnalyticsPreviewGraph: Identifiable {
    let id = UUID()
    let label: String
    let gradientStart: Color
    let gradientEnd: Color
    let score: Double
}
