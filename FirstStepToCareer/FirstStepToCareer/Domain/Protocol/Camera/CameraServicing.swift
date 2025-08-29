//
//  CameraServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import AVFoundation

protocol CameraServicing: AnyObject, Sendable {
    var session: AVCaptureSession { get }
    func prepareSession(preset: AVCaptureSession.Preset) async throws
    func setPreset(_ preset: AVCaptureSession.Preset) async
    func start() async
    func stop() async
    func setFrameDelivery(handler: @escaping @Sendable (CVPixelBuffer, CMTime) -> Void)
}
