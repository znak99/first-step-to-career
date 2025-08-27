//
//  LandmarkResult.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

struct LandmarkResult: Sendable {
    var boundingBox: CGRect
    var points: [CGPoint] // normalized [0,1]
}
