//
//  CameraService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import Foundation
import AVFoundation
import CoreMedia

/// CameraServicing 프로토콜 구현체
/// - 책임: AVCaptureSession 구성/시작/정지/해제, 프레임(CVPixelBuffer) 콜백 방출
/// - 비책임: 프리뷰 애니메이션/오버레이 그리기(→ View/VM에서 처리)
final class CameraService: NSObject, CameraServicing, @unchecked Sendable {

    // MARK: - Public (Protocol)
    let session = AVCaptureSession()

    func prepareSession(preset: AVCaptureSession.Preset) async throws {
        try await runOnSessionQueueThrowing { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = preset

            // 1) 디바이스 선택(전면 우선: TrueDepth → 와이드)
            guard let device = Self.bestFrontVideoDevice() else {
                throw CameraError.noAvailableCamera
            }

            // 2) 기존 입력/출력 제거(재구성 시 안정성)
            for input in self.session.inputs { self.session.removeInput(input) }
            if let output = self.videoOutput { self.session.removeOutput(output) }

            // 3) 입력 추가
            let input = try AVCaptureDeviceInput(device: device)
            guard self.session.canAddInput(input) else { throw CameraError.cannotAddInput }
            self.session.addInput(input)
            self.videoDeviceInput = input

            // 4) 출력 추가(프레임 콜백)
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(self, queue: sampleBufferQueue)

            guard self.session.canAddOutput(output) else { throw CameraError.cannotAddOutput }
            self.session.addOutput(output)
            self.videoOutput = output

            // 5) 연결 설정(전면 미러링, 기본 세로 방향)
            if let conn = output.connection(with: .video) {
                if conn.isVideoMirroringSupported { conn.isVideoMirrored = true }
            }

            self.session.commitConfiguration()
        }
    }

    func setPreset(_ preset: AVCaptureSession.Preset) async {
        await runOnSessionQueue { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            if self.session.canSetSessionPreset(preset) {
                self.session.sessionPreset = preset
            }
            self.session.commitConfiguration()
        }
    }

    func start() async {
        await runOnSessionQueue { [weak self] in
            guard let self, !self.session.isRunning else { return }
            self.session.startRunning() // 메인에서 호출 금지 → 전용 큐에서 실행
        }
    }

    func stop() async {
        await runOnSessionQueue { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    func setFrameDelivery(handler: @escaping @Sendable (CVPixelBuffer, CMTime) -> Void) {
        // 캡처 콜백에서 호출할 핸들러(분석 파이프라인으로 전달)
        frameHandler = handler
    }

    // MARK: - Convenience (Protocol 바깥 추가 기능)

    /// 세션 해체(입출력 제거 및 메모리 해제) – 화면 종료 시 확실히 정리하고 싶을 때 사용
    func teardown() async {
        await runOnSessionQueue { [weak self] in
            guard let self else { return }
            self.session.beginConfiguration()
            if let output = self.videoOutput { self.session.removeOutput(output) }
            for input in self.session.inputs { self.session.removeInput(input) }
            self.session.commitConfiguration()

            self.videoOutput = nil
            self.videoDeviceInput = nil
            self.frameHandler = nil
        }
    }

    // MARK: - Private
    private static func bestFrontVideoDevice() -> AVCaptureDevice? {
        // TrueDepth 전면 카메라가 있으면 우선 사용
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .front
        )
        // 우선순위: TrueDepth → 그 외 전면
        return discovery.devices.first { $0.deviceType == .builtInTrueDepthCamera }
            ?? discovery.devices.first
    }

    private var videoDeviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var frameHandler: (@Sendable (CVPixelBuffer, CMTime) -> Void)?

    // 전용 큐들: 세션 제어용 / 프레임 콜백용
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let sampleBufferQueue = DispatchQueue(label: "camera.samplebuffer.queue")

    // 세션/출력 관련 에러
    enum CameraError: Error {
        case noAvailableCamera
        case cannotAddInput
        case cannotAddOutput
    }

    // 세션 큐에서 동기 처리(에러 없는 버전)
    private func runOnSessionQueue(_ work: @escaping () -> Void) async {
        await withCheckedContinuation { cont in
            sessionQueue.async {
                work()
                cont.resume()
            }
        }
    }

    // 세션 큐에서 동기 처리(에러 전달 버전)
    private func runOnSessionQueueThrowing(_ work: @escaping () throws -> Void) async throws {
        try await withCheckedThrowingContinuation { cont in
            sessionQueue.async {
                do { try work(); cont.resume() }
                catch { cont.resume(throwing: error) }
            }
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    /// 프레임 수신 콜백(샘플 버퍼 → CVPixelBuffer 로 전달)
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else { return }
        let ts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        frameHandler?(pixelBuffer, ts)
    }
}
