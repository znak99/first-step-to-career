//
//  TTSService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation

// MARK: - 구현체
/// 정말 말하기만 하는 아주 작은 서비스.
@MainActor
public final class TTSService: NSObject, TTSServicing {

    // 최소 의존성: 오디오를 “한 번에 하나”만 쓰도록 조정
    private let audio: AudioSessionService

    // AVSpeechSynthesizer는 메인 스레드 사용이 안전
    private var synthesizer: AVSpeechSynthesizer?

    // 이벤트 스트림(오케스트레이터가 끝남을 받기 위함)
    private let eventStream: AsyncStream<TTSEvent>
    private var eventCont: AsyncStream<TTSEvent>.Continuation?

    public var events: AsyncStream<TTSEvent> { eventStream }

    // 세션 유지 여부만 추적(필요 이상 상태 관리는 하지 않음)
    private var isStarted = false

    // MARK: - Init
    public init(audio: AudioSessionService) {
        self.audio = audio
        var cont: AsyncStream<TTSEvent>.Continuation?
        self.eventStream = AsyncStream<TTSEvent> { cont = $0 }
        self.eventCont = cont
        super.init()
    }

    // MARK: - TTSServicing
    public func prepare() {
        // 준비는 정말 최소: 인스턴스만 만들어 둠
        if synthesizer == nil {
            let syn = AVSpeechSynthesizer()
            syn.delegate = self
            self.synthesizer = syn
        }
    }

    public func start() async {
        // 오디오 점유를 요청(실패해도 앱이 죽지는 않게 처리)
        _ = await audio.acquire(.tts)
        isStarted = true
    }

    public func pause() {
        synthesizer?.pauseSpeaking(at: .word)
    }

    public func resume() {
        _ = synthesizer?.continueSpeaking()
    }

    public func stop() {
        // 현재 읽기만 멈춤. 세션/인스턴스는 유지(빠른 재개를 위해)
        synthesizer?.stopSpeaking(at: .immediate)
    }

    public func shutdown() async {
        // 완전 종료: 읽기 중지 + 세션 반납 + 인스턴스 비움
        synthesizer?.stopSpeaking(at: .immediate)
        synthesizer?.delegate = nil
        synthesizer = nil
        isStarted = false
        await audio.release(.tts)
    }

    public func speak(text: String) {
        guard let synthesizer else { return }
        // 읽는 언어: 기본은 일본어. 필요 시 호출부에서 locale 전달.
        let lang = Locale(identifier: "ja-JP").identifier
        let utter = AVSpeechUtterance(string: text)
        utter.voice = AVSpeechSynthesisVoice(language: lang)
        utter.volume = 1.0
        utter.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        // 속도/피치/볼륨은 기본값(최소주의). 필요 시 오케스트레이터 쪽에서 조절.
        synthesizer.speak(utter)
    }
}

// MARK: - Delegate (이벤트를 최소만 전달)
extension TTSService: AVSpeechSynthesizerDelegate {
    public nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                              didStart utterance: AVSpeechUtterance) {
        // 메인 액터로 점프해서 MainActor-격리된 상태/프로퍼티에 접근
        Task { @MainActor [weak self] in
            self?.eventCont?.yield(.didStartUtterance)
        }
    }

    public nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                              didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor [weak self] in
            self?.eventCont?.yield(.didFinishUtterance)
        }
    }

    public nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                              didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor [weak self] in
            self?.eventCont?.yield(.didCancel)
        }
    }
}
