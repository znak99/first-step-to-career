//
//  TTSServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

// MARK: - 프로토콜(최소 기능만)
/// 화면과 직접 연결하지 않는, 말하기만 담당하는 약한 계약.
@MainActor
public protocol TTSServicing: AnyObject {
    /// TTS 상태 알림(시작/끝/취소). 오케스트레이터가 구독.
    var events: AsyncStream<TTSEvent> { get }

    /// 사전 준비(스피치 엔진 생성 등). 권한은 다른 서비스가 담당.
    func prepare()

    /// 오디오 세션을 TTS 용도로 점유. (STT와 동시 사용 방지)
    func start() async

    /// 현재 읽기를 멈추되, 재개를 위해 세션/인스턴스는 유지.
    func stop()

    /// 외부 요인 없이 스스로 전체 정지. 세션 반납 + 메모리 정리.
    func shutdown() async

    /// 일시정지/재개 (문장 단위가 아니라 현재 발화 기준)
    func pause()
    func resume()

    /// 실제 읽기. locale이 없으면 일본어(ja-JP)로 가정.
    func speak(text: String)
}
