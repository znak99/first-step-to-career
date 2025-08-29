//
//  SmileDetectionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import CoreVideo

// MARK: - Protocol
/// 웃음(스마일)만 검출하는 아주 단순한 약속.
/// 카메라 프레임을 넣어주면, 얼굴이 1명일 때만 계산하고 결과를 흘려보낸다.
public protocol SmileDetecting: Sendable {
    /// 결과 흐름(구독만 하면 됨)
    var results: AsyncStream<SmileResult> { get }

    /// 검출 준비(리퀘스트/큐 등 경량 리소스 세팅)
    func prepare()

    /// 검출 시작(연산 허용)
    func start()

    /// 일시 정지(연산 금지, 메모리는 유지)
    func pause()

    /// 재개(연산 재허용)
    func resume()

    /// 완전 중지(메모리/리소스 해제)
    func shutdown()

    /// 카메라 프레임을 밀어넣는 입구
    func process(_ pixelBuffer: CVPixelBuffer)
}
