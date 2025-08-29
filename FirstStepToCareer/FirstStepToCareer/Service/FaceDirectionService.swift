//
//  FaceDirectionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation
import Vision
import ARKit

// MARK: - 구현
public final class FaceDirectionService: NSObject, FaceDirectionDetecting, ARSessionDelegate, @unchecked Sendable {
    // 바인딩된 스트림을 읽는 작업(Task)
    // pause()에서는 취소하지 않고, shutdown()에서만 정리한다.
    private var framesTask: Task<Void, Never>?
    private var faceCountTask: Task<Void, Never>?
    
    // 실행 모드: TrueDepth가 되면 ARKit, 아니면 Vision
    private enum Mode { case arkit, vision }

    // 외부로 내보낼 스트림
    public var results: AsyncStream<HeadDirection> { stream }
    private var stream: AsyncStream<HeadDirection>
    private var continuation: AsyncStream<HeadDirection>.Continuation?

    // 상태
    private var mode: Mode = .vision
    private var isPrepared = false
    private var isRunning = false
    private var latestFaceCount: FaceCount = .none

    // Vision
    private let visionQueue = DispatchQueue(label: "face.direction.vision.queue")
    private var landmarksRequest: VNDetectFaceLandmarksRequest?
    private var isProcessingVision = false

    // ARKit(TrueDepth)
    private var arSession: ARSession?
    
    public var supportsARKit: Bool { mode == .arkit }

    public override init() {
        var tmpContinuation: AsyncStream<HeadDirection>.Continuation?
        self.stream = AsyncStream<HeadDirection> { cont in
            tmpContinuation = cont
        }
        self.continuation = tmpContinuation
        super.init()
    }

    // MARK: - Public API
    public func prepare() throws {
        guard !isPrepared else { return }

        // TrueDepth 가능 여부 판단
        if ARFaceTrackingConfiguration.isSupported {
            mode = .arkit
            let session = ARSession()
            session.delegate = self
            self.arSession = session
        } else {
            mode = .vision
            // yaw/roll 값을 얻기 위해 랜드마크 요청 사용
            self.landmarksRequest = VNDetectFaceLandmarksRequest()
        }

        isPrepared = true
    }

    public func start() {
        guard isPrepared, !isRunning else { return }
        isRunning = true

        if mode == .arkit {
            let config = ARFaceTrackingConfiguration()
            config.isLightEstimationEnabled = false
            // 전면 TrueDepth만 사용(전제)
            arSession?.run(config, options: [])
        }
    }

    public func pause() {
        guard isRunning else { return }
        isRunning = false

        if mode == .arkit {
            arSession?.pause()
        }
        // vision은 유지(큐/리퀘스트 그대로), run 플래그만 내려 비활성
    }

    public func resume() {
        guard isPrepared, !isRunning else { return }
        isRunning = true

        if mode == .arkit {
            let config = ARFaceTrackingConfiguration()
            config.isLightEstimationEnabled = false
            arSession?.run(config, options: [])
        }
    }

    public func shutdown() {
        isRunning = false
        isPrepared = false
        latestFaceCount = .none

        if mode == .arkit {
            arSession?.pause()
            arSession = nil
        }

        landmarksRequest = nil
        
        // ⬇️ 바인딩 작업 정리 (여기만 정리: pause()에서는 유지)
        framesTask?.cancel(); framesTask = nil
        faceCountTask?.cancel(); faceCountTask = nil
    }

    public func update(faceCount: FaceCount) {
        latestFaceCount = faceCount
    }

    public func process(_ pixelBuffer: CVPixelBuffer) {
        guard isRunning, latestFaceCount == .one else { return }

        switch mode {
        case .arkit:
            // ARKit 모드에선 ARSession(delegate)에서 값을 내보냄. 여기서는 할 일 없음.
            return

        case .vision:
            guard let request = landmarksRequest, !isProcessingVision else { return }
            isProcessingVision = true

            // 세로/전면/미러링은 카메라 서비스에서 맞췄다고 가정하고 .up 사용
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])

//            visionQueue.async { [weak self] in
//                guard let self else { return }
//                defer { self.isProcessingVision = false }
//
//                do {
//                    try handler.perform([request])
//
//                    // 가장 첫 얼굴만 사용(1명일 때만 호출하므로 안전)
//                    if let face = (request.results)?.first {
//                        // Vision은 roll/yaw만 제공(pitch 없음)
//                        let yaw = face.yaw?.floatValue ?? 0
//                        let roll = face.roll?.floatValue ?? 0
//                        self.continuation?.yield(HeadDirection(yaw: yaw, roll: roll, pitch: nil))
//                    }
//                } catch {
//                    // 실패 시 아무 것도 내보내지 않음(최소 동작 유지)
//                }
//            }
            
            visionQueue.async { [weak self] in
                guard let self else { return }
                defer { self.isProcessingVision = false }
                autoreleasepool {
                    do {
                        try handler.perform([request])
                        if let face = (request.results)?.first {
                            let yaw = face.yaw?.floatValue ?? 0
                            let roll = face.roll?.floatValue ?? 0
                            self.continuation?.yield(HeadDirection(yaw: yaw, roll: roll, pitch: nil))
                        }
                    } catch { /* 무시 */ }
                }
            }
        }
    }

    // MARK: - ARSessionDelegate (TrueDepth 전용)
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard isRunning, latestFaceCount == .one else { return }

        for anchor in anchors {
            guard let face = anchor as? ARFaceAnchor else { continue }
            // ARKit의 eulerAngles는 (pitch, yaw, roll) 순서로 제공(라디안)
            // - pitch: 위/아래, yaw: 좌/우, roll: 기울기
            let e = face.transformEulerAngles()
            continuation?.yield(HeadDirection(yaw: e.yaw, roll: e.roll, pitch: e.pitch))
        }
    }
    
    /// 카메라가 내보내는 프레임 스트림을 바인딩합니다.
    /// - 이미 바인딩되어 있으면 아무 것도 하지 않습니다.
    /// - pause() 상태여도 작업은 유지되고, start()/resume() 후 자동으로 처리됩니다.
    public func bind(frames: AsyncStream<PixelBufferBox>) {
        guard framesTask == nil else { return }
        framesTask = Task.detached { [weak self] in
            guard let self else { return }
            for await box in frames {
                // 실행 중이고 얼굴이 1명일 때만 내부에서 처리됨(가드로 필터링)
                self.process(box.buffer)
            }
        }
    }

    /// 얼굴 수 스트림을 바인딩합니다(0/1/2+명).
    /// - 이미 바인딩되어 있으면 아무 것도 하지 않습니다.
    /// - 최신 얼굴 수는 서비스 내부에 보관되어, 처리 여부를 결정합니다.
    public func bind(faceCounts: AsyncStream<FaceCount>) {
        guard faceCountTask == nil else { return }
        faceCountTask = Task.detached { [weak self] in
            guard let self else { return }
            for await count in faceCounts {
                self.update(faceCount: count)
            }
        }
    }
}

// MARK: - ARFaceAnchor -> Euler 변환 도우미 (간단 버전)
private extension ARFaceAnchor {
    /// 4x4 변환행렬에서 간단히 오일러각(pitch/yaw/roll, 라디안)을 구합니다.
    /// 자세한 수학 처리 대신 iOS에서 흔히 쓰는 방식의 최소 구현체입니다.
    func transformEulerAngles() -> (pitch: Float, yaw: Float, roll: Float) {
        // 변환행렬
        let m = transform
        // 참조: Tait–Bryan angles (YXZ 계열 등) 중 흔한 추정식의 간단 버전
        let sy = -m.columns.2.x
        let pitch = asin(sy)
        let yaw = atan2(m.columns.2.y, m.columns.2.z)
        let roll = atan2(m.columns.1.x, m.columns.0.x)
        return (pitch, yaw, roll)
    }
}
