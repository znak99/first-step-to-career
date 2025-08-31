//
//  FaceDirectionDetecting.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import CoreVideo

/// 얼굴 방향 검출 서비스가 외부와 약속하는 최소한의 기능입니다.
/// - 준비/시작/정지/재개/중지 제어
/// - 프레임 입력
/// - 현재 얼굴 수 입력 (1명일 때만 처리)
/// - 결과 스트림(FaceDirection) 제공
public protocol FaceDirectionDetecting: Sendable {
    var results: AsyncStream<FaceDirection> { get }

    func prepare() throws
    func start()
    func pause()
    func resume()
    func shutdown()

    func process(_ pixelBuffer: CVPixelBuffer)
    func updateFaceCount(_ count: FaceCount)
}
