//
//  CameraServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import AVFoundation

/// 화면에 보이는 카메라를 다루는 가장 작은 약속입니다.
/// - 준비: 세션을 만들고 전면 카메라를 붙입니다.
/// - 시작/정지/재개/완전중지: 이름 그대로 동작합니다.
/// - 프레임: Vision/ARKit에서 바로 쓸 수 있도록 픽셀 버퍼를 흘려보냅니다.
/// - TrueDepth 지원 여부를 알려줍니다.
public protocol CameraServicing: Sendable {
    /// 미리보기(프리뷰)에서 사용할 세션입니다.
    var session: AVCaptureSession { get }

    /// 프레임을 실시간으로 받는 흐름입니다.
    var frames: AsyncStream<PixelBufferBox> { get }

    /// 세션을 구성합니다. (권한 확인/요청은 별도 서비스에서 처리한다고 가정)
    func prepareSession() throws

    /// 카메라 시작 (실행)
    func start()

    /// 일시 정지 (세션/입출력은 유지, 메모리 유지)
    func pause()

    /// 일시 정지에서 재개
    func resume()

    /// 완전 중지 (세션 정지 + 입력/출력 제거로 메모리 해제)
    func shutdown()
}
