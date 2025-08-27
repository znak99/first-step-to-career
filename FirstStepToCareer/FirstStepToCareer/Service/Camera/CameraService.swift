//
//  CameraService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import AVFoundation

final class CameraService: @unchecked Sendable, CameraServicing {

    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private var isConfigured = false
    private var currentConfig: CameraConfig = .default
    
    func configure(_ config: CameraConfig = .default) {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.currentConfig = config
            self.applyConfiguration(config)
            self.isConfigured = true
        }
    }

    func startRunning() {
        sessionQueue.async { [weak self] in
            guard let self, self.isConfigured, !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }

    func stopRunning() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    private func applyConfiguration(_ config: CameraConfig) {
        session.beginConfiguration()
        session.sessionPreset = config.preset

        for input in session.inputs {
            session.removeInput(input)
        }

        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else {
            session.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            session.commitConfiguration()
            return
        }

        session.commitConfiguration()

        if let connection = (session.connections.first { $0.isVideoMirroringSupported }) {
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = true
            }
        }
    }
}
