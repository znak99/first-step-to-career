//
//  InterviewControlling.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import AVFoundation

@MainActor
protocol InterviewControlling: AnyObject, Sendable {

    // ====== 상태 바인딩(뷰/뷰모델에서 직접 읽기) ======
    var currentState: InterviewState { get }      // idle/preparing/precheck/running/...
    var cameraSession: AVCaptureSession { get }   // 미리보기용
    var overlay: OverlayState { get }             // 얼굴박스/시선/표정
    var transcript: String { get }                // 최신 음성 인식 텍스트(프리체크/러닝 공통)
    var currentQuestion: String? { get }          // 러닝 시 현재 질문(프리체크에서는 nil)
    var isSpeaking: Bool { get }                  // TTS 재생 상태
    var scores: InterviewScores? { get }          // Stop 이후 Evaluate에서 채워짐
    var feedback: InterviewFeedback? { get }      // Feedback 생성 후 채워짐
    var lastError: String? { get }

    // ====== 라이프사이클 ======
    /// 폼 제출 후 호출: 권한 프리플라이트/리소스 준비/초기 질문 프리페치
    func prepare(info: InterviewContext) async

    /// 프리체크 진입: 카메라 프리뷰 + 시선/표정/마이크 테스트 가능
    /// (이 시점은 면접 "시작 전". 로그/점수 집계는 하지 않음)
    func beginPrecheck() async

    /// 프리체크 화면에서 "마이크 테스트용 TTS" 실행(선택)
    func testSpeak(_ text: String) async

    /// "면접 시작" 버튼을 눌렀을 때: 러닝 상태로 전환(질문 발화→STT 청취)
    func start() async

    /// 일시정지/재개/종료
    func pause() async
    func resume() async
    func stop() async         // 스트림 종료 → Evaluate → Feedback → finished
    func cancel() async       // 세션 폐기(저장/평가 없이 종료)

    // ====== UI 이벤트 스트림(토스트/알럿/햅틱) ======
    var uiEvents: AsyncStream<InterviewUIEvent> { get }
}
