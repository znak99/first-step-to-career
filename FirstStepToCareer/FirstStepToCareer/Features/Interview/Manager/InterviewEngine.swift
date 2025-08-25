//
//  InterviewEngine.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI
import Foundation
import AVFoundation

@MainActor
final class InterviewEngine: ObservableObject {
    private let camera: CameraServicing
    private let permission: PermissionService
    private let stt: STTServicing

    @Published private(set) var isReady: Bool = false
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var lastError: String?
    @Published private(set) var transcript: String = ""

    var cameraSession: AVCaptureSession { camera.session }
    private(set) var interviewInfo: InterviewInfo?

    init(camera: CameraServicing = CameraService(),
         permission: PermissionService = PermissionService(),
         stt: STTServicing = STTService(locale: .init(identifier: "ja-JP"))) {
        self.camera = camera
        self.permission = permission
        self.stt = stt

        self.stt.onUpdate = { [weak self] text in
            Task { @MainActor in self?.transcript = text }
        }
        self.stt.onError = { [weak self] error in
            Task { @MainActor in self?.lastError = error.localizedDescription }
        }
        self.stt.onFinished = { [weak self] in
            Task { @MainActor in self?.isRunning = false }
        }
    }

    func prepare(info: InterviewInfo, config: CameraConfig = .default) async {
        interviewInfo = info
        lastError = nil
        isReady = false
        transcript = ""

        let permissions = await permission.requestCameraMicSpeech()

        guard permissions.camera else {
            lastError = "カメラの権限がありません。"
            return
        }
        guard permissions.mic else {
            lastError = "マイクの権限がありません。"
            return
        }
        guard permissions.speech else {
            lastError = "音声認識の権限がありません。"
            return
        }

        camera.configure(config)
        isReady = true
    }

    func start() {
        guard isReady else {
            lastError = "面接準備がまだです。"
            return
        }
        camera.startRunning()
        stt.start()
        isRunning = true
    }

    func stop() {
        stt.stop()
        camera.stopRunning()
        isRunning = false
    }

    func teardown() {
        stop()
        interviewInfo = nil
        isReady = false
        transcript = ""
        lastError = nil
    }
}
