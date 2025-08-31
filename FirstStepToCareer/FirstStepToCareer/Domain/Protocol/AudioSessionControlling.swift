//
//  AudioSessionControlling.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

/// 앱에서 오디오 세션을 한곳에서 관리하기 위한 아주 간단한 계약
/// - 세션을 직접 만지는 것은 이 프로토콜을 구현한 서비스만 하도록 합니다.
public protocol AudioSessionControlling: Sendable {
    /// 현재 상태 확인용(읽기 전용)
    var state: AudioState { get async }

    /// 공용 준비: 카테고리/옵션 설정, 알림 구독
    func prepare() async throws

    /// 점유 요청: 현재 점유자가 있더라도 즉시 전환(우선순위 없음)
    @discardableResult
    func acquire(_ client: AudioClient) async -> Bool

    /// 점유 반납: 해당 클라이언트가 점유 중일 때만 idle로 전환
    func release(_ client: AudioClient) async

    /// 외부 중단(전화/시리 등) 시작 시 호출
    func pauseAll() async

    /// 외부 중단이 끝났을 때, 가능하면 직전 점유자로 복귀
    func resumeIfNeeded() async

    /// 마무리 정리: 알림 해제, 세션 비활성화
    func shutdown() async
}
