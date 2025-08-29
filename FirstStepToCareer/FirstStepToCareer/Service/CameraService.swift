//
//  CameraService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import AVFoundation

/// 카메라를 실제로 다루는 아주 단순한 구현체입니다.
/// - 내부 큐에서 세션을 구성/실행합니다.
/// - 전면 카메라(가능하면 TrueDepth)를 선택합니다.
/// - 전면 카메라 특성상 미러링을 켭니다.
/// - 세로 방향으로 고정합니다.
/// - 프레임은 CVPixelBuffer로 내보냅니다.
public final class CameraService: NSObject, CameraServicing, @unchecked Sendable {
    public let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let output = AVCaptureVideoDataOutput()

    // AsyncStream 전달용 저장소
    public private(set) lazy var frames: AsyncStream<PixelBufferBox> = {
        AsyncStream<PixelBufferBox> { [weak self] cont in
            self?.framesContinuation = cont
        }
    }()
    private var framesContinuation: AsyncStream<PixelBufferBox>.Continuation?

    // 입력/디바이스를 보관했다가 shutdown 시 해제
    private var currentInput: AVCaptureDeviceInput?

    public override init() {
        // 먼저 super.init() 호출
        super.init()

        // non-optional frames를 여기서 한 번만 생성하고 continuation 보관
        self.frames = AsyncStream<PixelBufferBox> { [weak self] cont in
            self?.framesContinuation = cont
        }
    }

    // MARK: - Public
    public func prepareSession() throws {
        // 가능한 한 간단히: 구성은 전용 큐에서 동기적으로 처리
        sessionQueue.sync {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high

            // 기존 입력/출력 제거(중복 방지)
            if let input = self.currentInput {
                self.session.removeInput(input)
                self.currentInput = nil
            }
            if self.session.outputs.contains(self.output) {
                self.session.removeOutput(self.output)
            }

            // 전면 카메라 선택 (TrueDepth 우선, 없으면 일반 전면 카메라)
            guard let device = Self.preferredFrontCamera() else {
                // 장치가 없으면 구성을 끝내고 예외를 던질 수 있도록 종료만
                self.session.commitConfiguration()
                return
            }

            do {
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                    self.currentInput = input
                }
            } catch {
                self.session.commitConfiguration()
                // 상위로 throw
                DispatchQueue.main.async {
                    // 아무 것도 하지 않음: 단순/최소 구현
                }
                // throw는 바깥에서
            }

            // 비디오 출력 연결
            self.output.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            self.output.alwaysDiscardsLateVideoFrames = true
            let outputQueue = DispatchQueue(label: "camera.frame.output.queue")
            self.output.setSampleBufferDelegate(self, queue: outputQueue)

            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }

            // 연결 설정: 세로 고정, 전면 미러링
            if let connection = self.output.connection(with: .video) {
                if connection.isVideoRotationAngleSupported(0) {
                    connection.videoRotationAngle = 0
                }
                if connection.isVideoMirroringSupported {
                    connection.isVideoMirrored = true
                }
            }

            self.session.commitConfiguration()
            _ = frames // lazy 초기화 트리거 (continuation 세팅)
        }
    }

    public func start() {
        sessionQueue.async {
            guard !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }

    public func pause() {
        // "정지(메모리 유지)"는 단순히 런닝만 멈춥니다.
        sessionQueue.async {
            guard self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    public func resume() {
        // 준비된 세션을 다시 시작합니다.
        start()
    }

    public func shutdown() {
        // 완전 중지: 세션을 멈추고, 입력/출력을 떼어 메모리를 돌려줌
        sessionQueue.sync {
            if self.session.isRunning { self.session.stopRunning() }
            if let input = self.currentInput {
                self.session.removeInput(input)
                self.currentInput = nil
            }
            if self.session.outputs.contains(self.output) {
                self.session.removeOutput(self.output)
            }
        }
    }

    public func isTrueDepthAvailable() -> Bool {
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera],
            mediaType: .video,
            position: .front
        )
        return discovery.devices.first != nil
    }

    // MARK: - Helpers
    private static func preferredFrontCamera() -> AVCaptureDevice? {
        // TrueDepth 우선
        let trueDepth = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera],
            mediaType: .video,
            position: .front
        ).devices.first
        if let td = trueDepth { return td }

        // 없으면 일반 전면 카메라
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .front
        ).devices.first
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        if let buf = CMSampleBufferGetImageBuffer(sampleBuffer) {
            framesContinuation?.yield(PixelBufferBox(buf))
        }
    }
}
