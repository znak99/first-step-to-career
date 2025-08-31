//
//  FaceDirectionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation
import Vision

/// Vision을 사용해 yaw/roll을 계산하는 간단한 구현체입니다.
/// - 내부 큐는 직렬로 돌려 불필요한 중복 처리를 막습니다.
/// - 실패/부적합인 경우에는 값을 방출하지 않습니다(최소 동작 보장에 집중).
public final class FaceDirectionService: @unchecked Sendable, FaceDirectionDetecting {

    // MARK: Outputs
    public var results: AsyncStream<FaceDirection> { stream }
    private let stream: AsyncStream<FaceDirection>
    private var continuation: AsyncStream<FaceDirection>.Continuation?

    // MARK: State
    private let queue = DispatchQueue(label: "face.direction.vision.queue")
    private var request: VNDetectFaceLandmarksRequest?
    private var isRunning = false
    private var isProcessing = false
    private var currentFaceCount: FaceCount = .none

    // MARK: Init
    public init() {
        let tuple = AsyncStream<FaceDirection>.makeStream()
        self.stream = tuple.stream
        self.continuation = tuple.continuation
    }

    // MARK: Lifecycle
    public func prepare() throws {
        // 랜드마크 요청을 사용하면 관찰 값에 yaw/roll이 함께 오는 경우가 많습니다.
        let req = VNDetectFaceLandmarksRequest()
        self.request = req
    }

    public func start() {
        isRunning = true
    }

    public func pause() {
        isRunning = false
    }

    public func resume() {
        isRunning = true
    }

    public func shutdown() {
        isRunning = false
        request = nil
        continuation?.finish()
        continuation = nil
    }

    // MARK: Inputs
    public func updateFaceCount(_ count: FaceCount) {
        currentFaceCount = count
    }

    public func process(_ pixelBuffer: CVPixelBuffer) {
        guard isRunning, currentFaceCount == .one, let request = self.request, !isProcessing else { return }
        isProcessing = true

        queue.async { [weak self] in
            guard let self else { return }
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])

            do {
                try handler.perform([request])

                // 첫 번째 얼굴만 사용 (최소 구현)
                if let face = request.results?.first {
                    // yaw/roll은 라디안으로 올 수 있습니다. 둘 다 존재할 때만 방출합니다.
                    if let yawRad = face.yaw?.doubleValue, let rollRad = face.roll?.doubleValue {
                        let dir = FaceDirection(yaw: yawRad * 180.0 / .pi,
                                                roll: rollRad * 180.0 / .pi)
                        self.continuation?.yield(dir)
                    }
                }
            } catch {
                // 최소 구현: 실패 시 아무 값도 방출하지 않음
            }

            self.isProcessing = false
        }
    }
}
