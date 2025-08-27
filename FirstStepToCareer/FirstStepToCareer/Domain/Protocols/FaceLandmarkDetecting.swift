//
//  FaceLandmarkDetecting.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation
import CoreMedia

protocol FaceLandmarkDetecting: Sendable {
    func process(frame: CVPixelBuffer, at time: CMTime) async
    func setOutput(handler: @escaping @Sendable (LandmarkResult) -> Void)
}
