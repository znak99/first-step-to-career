//
//  GazeTracking.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

@MainActor
protocol GazeTracking: Sendable {
    func update(landmarks: LandmarkResult)
    func setOutput(handler: @escaping @Sendable (GazeVector) -> Void)
}
