//
//  CameraService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

@preconcurrency import AVFoundation   // AVFoundation의 Sendable 경고 억제
import Foundation
import Vision

final class CameraService: ObservableObject {
    // 캡처 그래프
    let session = AVCaptureSession()

    // 상태/큐
    private var configured = false
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    // Vision 결과(캡처 디바이스 좌표: 0~1, 원점 좌상)
    @Published var gazeDevicePoint: CGPoint?

    // 비디오 델리게이트 (샘플 버퍼 처리)
    private let videoDelegate = VideoOutputDelegate()

    enum CameraError: Error {
        case permissionDenied
        case noCamera
    }

    // MARK: - Configure
    func configureIfNeeded() async throws {
        guard !configured else { return }

        // 권한
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted { throw CameraError.permissionDenied }
        default:
            throw CameraError.permissionDenied
        }

        // Vision 콜백은 Sendable 클로저 바깥에서 설정(여기서 self 캡처 OK)
        videoDelegate.onGazePoint = { [weak self] devicePoint in
            Task { @MainActor in
                self?.gazeDevicePoint = devicePoint
            }
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // Sendable 클로저에서 self 캡처 대신 필요한 레퍼런스만 값 캡처
            let session = self.session
            let videoDelegate = self.videoDelegate
            let sessionQueue = self.sessionQueue

            sessionQueue.async {
                do {
                    session.beginConfiguration()
                    session.sessionPreset = .high

                    // 전면 카메라 입력
                    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                               for: .video,
                                                               position: .front) else {
                        throw CameraError.noCamera
                    }
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) { session.addInput(input) }

                    // 비디오 데이터 출력
                    let videoOutput = AVCaptureVideoDataOutput()
                    videoOutput.alwaysDiscardsLateVideoFrames = true
                    videoOutput.videoSettings = [
                        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                    ]
                    if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }

                    // 세로 회전 (iOS 17+)
                    if let conn = videoOutput.connection(with: .video) {
                        if #available(iOS 17.0, *) {
                            conn.videoRotationAngle = 90
                        }
                    }

                    session.commitConfiguration()

                    // 샘플 버퍼 델리게이트 설정 (전용 큐)
                    let videoQueue = DispatchQueue(label: "camera.video.output.queue")
                    videoOutput.setSampleBufferDelegate(videoDelegate, queue: videoQueue)

                    // 여기서는 self에 접근하지 않음 (configured는 바깥에서 설정)
                    continuation.resume()
                } catch {
                    session.commitConfiguration()
                    continuation.resume(throwing: error)
                }
            }
        }

        // 성공적으로 구성 완료 → 메인에서 상태 갱신(여기서는 self 접근 안전)
        await MainActor.run { self.configured = true }
    }

    // MARK: - Control
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

    func stop() {
        let session = self.session
        let sessionQueue = self.sessionQueue
        sessionQueue.async {
            if session.isRunning { session.stopRunning() }
        }
    }
}

// MARK: - VideoOutputDelegate (Vision)
private final class VideoOutputDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    /// Vision에서 계산된 시선 포인트(캡처 디바이스 좌표 0~1, 원점 좌상)
    var onGazePoint: ((CGPoint?) -> Void)?

    // 간단한 처리 스로틀 (~20fps)
    private var lastProcessTime: CFTimeInterval = 0
    private let minInterval: CFTimeInterval = 0.05

    private lazy var request: VNDetectFaceLandmarksRequest = {
        VNDetectFaceLandmarksRequest(completionHandler: handleFaceLandmarks)
    }()

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        let now = CACurrentMediaTime()
        if now - lastProcessTime < minInterval { return }
        lastProcessTime = now

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // 전면 + 세로 + 프리뷰 미러 기준 EXIF 방향
        let exifOrientation = CGImagePropertyOrientation.rightMirrored

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: exifOrientation,
                                            options: [:])
        do {
            try handler.perform([request])
        } catch {
            onGazePoint?(nil)
        }
    }

    private func handleFaceLandmarks(request: VNRequest, error: Error?) {
        guard error == nil,
              let observations = request.results as? [VNFaceObservation],
              let face = observations.first else {
            onGazePoint?(nil)
            return
        }

        // 얼굴 내부(정규화, 원점: 얼굴 bbox 좌하)에서 시선 후보 좌표
        let normalizedInFace: CGPoint? = {
            if let p = face.landmarks?.pupilsAveragePoint { return p }     // 동공 평균점
            if let c = face.landmarks?.eyesCenterPoint   { return c }     // 눈 중심 평균점
            return nil
        }()

        guard let inFace = normalizedInFace else {
            onGazePoint?(nil)
            return
        }

        // 얼굴 bbox(정규화, 원점: 전체 이미지 좌하) → 전체 이미지 정규화
        let bbox = face.boundingBox
        let imageNormX = bbox.origin.x + inFace.x * bbox.size.width
        let imageNormY = bbox.origin.y + inFace.y * bbox.size.height

        // 캡처 디바이스 좌표(0~1, 원점: 좌상)
        let devicePoint = CGPoint(x: imageNormX, y: 1.0 - imageNormY)
        onGazePoint?(devicePoint)
    }
}

// MARK: - Vision 편의 확장
private extension VNFaceLandmarks2D {
    /// 동공 두 개 평균(정규화 좌표)
    var pupilsAveragePoint: CGPoint? {
        guard let lp = leftPupil?.normalizedPoints, !lp.isEmpty,
              let rp = rightPupil?.normalizedPoints, !rp.isEmpty else { return nil }
        let l = average(of: lp), r = average(of: rp)
        return CGPoint(x: (l.x + r.x) * 0.5, y: (l.y + r.y) * 0.5)
    }

    /// 양쪽 눈 컨투어 중심의 평균(정규화 좌표)
    var eyesCenterPoint: CGPoint? {
        guard let lPts = leftEye?.normalizedPoints, !lPts.isEmpty,
              let rPts = rightEye?.normalizedPoints, !rPts.isEmpty else { return nil }
        let l = average(of: lPts), r = average(of: rPts)
        return CGPoint(x: (l.x + r.x) * 0.5, y: (l.y + r.y) * 0.5)
    }

    func average(of points: [CGPoint]) -> CGPoint {
        let sum = points.reduce(.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        let n = CGFloat(points.count)
        return CGPoint(x: sum.x / n, y: sum.y / n)
    }
}
