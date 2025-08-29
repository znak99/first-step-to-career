//
//  FaceDirectionDetecting.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import CoreVideo

// MARK: - 프로토콜
/// 카메라 프레임(또는 TrueDepth)을 이용해 얼굴 방향을 계산해 내보냅니다.
public protocol FaceDirectionDetecting: Sendable {
    /// 계산된 얼굴 방향을 실시간으로 내보냅니다.
    var results: AsyncStream<HeadDirection> { get }

    /// 내부 준비(리소스 생성). 권한 체크는 외부 서비스에서 처리했다고 가정합니다.
    func prepare() throws

    /// 계산 시작(실행). 세션/큐를 활성화합니다.
    func start()

    /// 일시 정지(메모리는 유지). 필요 시 재개 가능합니다.
    func pause()

    /// 일시 정지에서 재개.
    func resume()

    /// 완전 중지(리소스 해제).
    func shutdown()

    /// 카메라가 내보낸 프레임을 전달합니다. (ARKit 모드에선 무시됩니다)
    func process(_ pixelBuffer: CVPixelBuffer)

    /// 얼굴 수가 바뀔 때마다 호출해 주세요. (0/1/2+명)
    func update(faceCount: FaceCount)
}
