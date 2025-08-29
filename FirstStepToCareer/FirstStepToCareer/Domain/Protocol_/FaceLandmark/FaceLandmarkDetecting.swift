//
//  FaceLandmarkDetecting.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation
import CoreMedia

// Path: Domain/Protocols/FaceLandmarkDetecting.swift
@MainActor
protocol FaceLandmarkDetecting: Sendable {
    func process(frame: CVPixelBuffer, at time: CMTime)
    func setOutput(handler: @escaping @Sendable (LandmarkResult) -> Void)
}

