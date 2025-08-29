//
//  FaceDetecting.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import CoreVideo

/// 얼굴 개수 검출 서비스가 지켜야 하는 약속(가벼운 인터페이스)
public protocol FaceDetecting: Sendable {
    /// 준비(리소스 세팅). 여러 번 불러도 안전해야 함.
    func prepare()

    /// 검출 가능 상태 시작(실제로 계산함)
    func start()

    /// 검출 가능 상태 정지(메모리는 유지)
    func pause()

    /// 일시정지에서 다시 시작
    func resume()

    /// 완전 중지(메모리 해제)
    func shutdown()

    /// 카메라가 내보낸 프레임을 넣는다. (세로고정/전면카메라 가정)
    func process(_ pixelBuffer: CVPixelBuffer)

    /// 검출 결과를 바깥으로 계속 내보내는 통로
    var results: AsyncStream<FaceCount> { get }
}
