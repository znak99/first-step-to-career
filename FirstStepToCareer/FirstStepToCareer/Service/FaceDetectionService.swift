//
//  FaceDetectionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation
import Vision

/// Vision 기반 최소 구현체
public final class FaceDetectionService: @unchecked Sendable, FaceDetecting {
    
    // MARK: - Public Stream
    public var results: AsyncStream<FaceCount> { stream }
    
    // MARK: - Private
    private let queue = DispatchQueue(label: "vision.face.detect.queue")
    private var request: VNDetectFaceRectanglesRequest?
    private var isPrepared = false
    private var isRunning = false
    private var isProcessing = false  // 프레임 과부하 방지용(한 번에 하나만 처리)
    
    private let stream: AsyncStream<FaceCount>
    private var continuation: AsyncStream<FaceCount>.Continuation?
    
    // MARK: - Init
    public init() {
        var c: AsyncStream<FaceCount>.Continuation!
        self.stream = AsyncStream<FaceCount> { cont in
            c = cont
        }
        self.continuation = c
    }
    
    // MARK: - Lifecycle
    public func prepare() {
        guard !isPrepared else { return }
        // 얼굴 사각형만 찾는 가장 가벼운 요청
        let req = VNDetectFaceRectanglesRequest()
        self.request = req
        isPrepared = true
    }
    
    public func start() {
        guard isPrepared else {
            prepare()
            return
        }
        isRunning = true
    }
    
    public func pause() {
        isRunning = false
    }
    
    public func resume() {
        guard isPrepared else {
            prepare()
            return
        }
        isRunning = true
    }
    
    public func shutdown() {
        isRunning = false
        isPrepared = false
        request = nil
        // 스트림은 끊지 않습니다. (원하면 여기서 종료를 선택적으로 할 수 있음)
    }
    
    // MARK: - Frame In
    public func process(_ pixelBuffer: CVPixelBuffer) {
        guard isRunning, let request = self.request, !isProcessing else { return }
        isProcessing = true
        
        // Vision은 스레드 분리해서 돌려도 됩니다. (여기서는 단일 직렬 큐)
        queue.async { [weak self] in
            guard let self else { return }
            // 세로/전면/미러링은 이미 카메라 쪽에서 맞춰져 있다고 가정하고 .up 사용
            // (필요하면 호출부에서 VNImageOrientation을 계산해 전달하도록 확장 가능)
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            
            do {
                try handler.perform([request])
                let count = (request.results)?.count ?? 0
                let mapped: FaceCount = {
                    switch count {
                    case 0: return .none
                    case 1: return .one
                    default: return .many
                    }
                }()
                
                // 결과 방출
                self.continuation?.yield(mapped)
            } catch {
                // 실패 시에도 UI가 멈추지 않도록 0명으로 처리 (최소 동작 보장)
                self.continuation?.yield(.none)
            }
            
            self.isProcessing = false
        }
    }
}
