//
//  CameraService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

@preconcurrency import AVFoundation
import Foundation

/// 전면 카메라 프리뷰 전용 최소 서비스 (iOS 17+)
final class CameraService: ObservableObject {
    let session = AVCaptureSession()

    private var configured = false
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    enum CameraError: Error {
        case permissionDenied
        case noCamera
        case failedToConfigure
    }

    /// 권한 확인 후 전면 카메라 세션 구성 (한 번만)
    func configureIfNeeded() async throws {
        guard !configured else { return }

        // 1) 권한
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted { throw CameraError.permissionDenied }
        default:
            throw CameraError.permissionDenied
        }

        // 2) 세션 구성 (Sendable 경고 회피: self 캡처 대신 값 캡처)
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            let session = self.session
            let sessionQueue = self.sessionQueue

            sessionQueue.async {
                do {
                    session.beginConfiguration()
                    session.sessionPreset = .high

                    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                               for: .video,
                                                               position: .front) else {
                        throw CameraError.noCamera
                    }

                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) { session.addInput(input) }

                    let videoOutput = AVCaptureVideoDataOutput()
                    // 프리뷰만이면 굳이 추가하지 않아도 되지만,
                    // 일부 디바이스에서 안정적 연결을 위해 붙여도 무방함(필요 없으면 제거 가능)
                    if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }

                    if let conn = videoOutput.connection(with: .video) {
                        if #available(iOS 17.0, *) {
                            conn.videoRotationAngle = 90 // 세로
                        }
                    }

                    session.commitConfiguration()
                    cont.resume()
                } catch {
                    session.commitConfiguration()
                    cont.resume(throwing: error)
                }
            }
        }

        // 3) 외부 상태 플래그는 메인에서 갱신 (Sendable 경고 방지)
        await MainActor.run { self.configured = true }
    }

    /// 세션 시작
    func start() async {
        let session = self.session
        let sessionQueue = self.sessionQueue
        await withCheckedContinuation { (c: CheckedContinuation<Void, Never>) in
            sessionQueue.async {
                if !session.isRunning { session.startRunning() }
                c.resume()
            }
        }
    }

    /// 세션 정지
    func stop() {
        let session = self.session
        let sessionQueue = self.sessionQueue
        sessionQueue.async {
            if session.isRunning { session.stopRunning() }
        }
    }
}
