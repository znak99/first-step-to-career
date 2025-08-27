//
//  CameraConfig.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import Foundation
import AVFoundation

struct CameraConfig {
    var preset: AVCaptureSession.Preset = .high
    static let `default` = CameraConfig()
}
