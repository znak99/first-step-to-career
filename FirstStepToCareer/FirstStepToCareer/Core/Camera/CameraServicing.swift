//
//  CameraServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/25.
//

import AVFoundation

protocol CameraServicing: Sendable {
    var session: AVCaptureSession { get }
    func configure(_ config: CameraConfig)
    func startRunning()
    func stopRunning()
}
