//
//  InterviewEngine.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI
import Foundation
import AVFoundation
import Combine // [ADDED] TTS/STT 상태 구독을 위해 추가

@MainActor
final class InterviewOrchestrator: ObservableObject {
    private let camera: CameraServicing
    private let stt: STTStreaming
    private let tts: TTSServicing
    private let permission: PermissionService
    private let audio: AudioService

    // [ADDED]
    private var bag = Set<AnyCancellable>()
    // [ADDED] TTS에 의해 일시 중지되었는지 추적(원치 않는 재시작 폭주 방지)
    private var pausedByTTS = false

    @Published private(set) var isReady: Bool = false
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var transcript: String = ""
    @Published private(set) var isTTSSpeaking: Bool = false // [ADDED] UI 표시용

    var cameraSession: AVCaptureSession { camera.session }
    private(set) var interviewInfo: InterviewInfo?

    init(
        camera: CameraServicing? = nil,
        stt: STTStreaming? = nil,
        tts: TTSServicing? = nil,
        permission: PermissionService? = nil,
        audio: AudioService? = nil
    ) {
        self.camera = camera ?? CameraService()
        self.stt = stt ?? STTService(locale: .init(identifier: "ja-JP"))
        self.tts = tts ?? TTSService()
        self.permission = permission ?? PermissionService()
        self.audio = audio ?? AudioService()

        // [ADDED] STT 스트림 구독 → 엔진 상태 반영
        self.stt.transcriptPublisher
            .removeDuplicates()
            .debounce(for: .milliseconds(120), scheduler: DispatchQueue.main)
            .sink { [weak self] text in self?.transcript = text }
            .store(in: &bag)

        self.stt.isRunningPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] running in self?.isRunning = running }
            .store(in: &bag)

        self.stt.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] err in self?.errorMessage = err.localizedDescription }
            .store(in: &bag)

        // [UPDATED] 핵심: TTS ↔ STT 자동 연동
        self.tts.isSpeakingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] speaking in
                guard let self else { return }
                self.isTTSSpeaking = speaking
                if speaking {
                    // TTS 시작 → STT를 반드시 중지
                    if self.isRunning {
                        self.pausedByTTS = true // [ADDED] TTS가 멈추면 재개할 수 있게 플래그
                        self.stt.stop()
                    } else {
                        // 이미 STT off여도 TTS가 켜졌다는 사실만 기록
                        self.pausedByTTS = true
                    }
                } else {
                    // TTS 종료 → 준비 상태라면 STT를 켠다 (요구사항 준수)
                    guard self.isReady else { return }
                    // pausedByTTS 여부와 무관하게 '끝나면 켠다' 요구사항을 그대로 적용:
                    self.stt.start()
                    self.pausedByTTS = false
                }
            }
            .store(in: &bag)
    }

    func prepare(info: InterviewInfo, config: CameraConfig = .default) async {
        interviewInfo = info
        errorMessage = nil
        isReady = false
        transcript = ""

        let permissions = await permission.requestCameraMicSpeech()

        guard permissions.camera else {
            errorMessage = "カメラの権限がありません."
            return
        }
        guard permissions.mic else {
            errorMessage = "マイクの権限がありません."
            return
        }
        guard permissions.speech else {
            errorMessage = "音声認識の権限がありません."
            return
        }

        do {
            try audio.setCategoryForInterview()
        } catch {
            errorMessage = "オーディオの初期化に失敗しました: \(error.localizedDescription)"
            return
        }

        camera.configure(config)
        isReady = true
    }

    func start() {
        guard isReady else {
            errorMessage = "面接準備がまだです。"
            return
        }
        guard !isRunning else { return }

        camera.startRunning()

        do {
            try audio.activateSession(true)
        } catch {
            errorMessage = "オーディオを有効化できませんでした: \(error.localizedDescription)"
            camera.stopRunning()
            return
        }

        // [UPDATED] STT는 사용 시작 시점에 켠다.
        stt.start()
        // isRunning은 Publisher로 자동 갱신됨
    }

    func stop() {
        guard isRunning || isTTSSpeaking else { // [UPDATED] TTS만 도는 중에 stop 눌러도 안전
            return
        }

        // [UPDATED] 모든 오디오 활동 정리: STT/TTS
        stt.stop()
        tts.stop() // TTS가 재생 중이면 즉시 중단
        camera.stopRunning()
        do {
            try audio.activateSession(false)
        } catch {
            #if DEBUG
            print("Audio deactivate error: \(error)")
            #endif
        }
        pausedByTTS = false // [ADDED]
        // isRunning은 Publisher로 자동 false 전환
    }

    func teardown() {
        if isRunning || isTTSSpeaking { // [UPDATED] TTS 재생 중에도 안전 종료
            stop()
        } else {
            camera.stopRunning()
            try? audio.activateSession(false)
        }
        interviewInfo = nil
        isReady = false
        transcript = ""
        errorMessage = nil
        pausedByTTS = false // [ADDED]
    }

    // MARK: - (선택) 질문 읽기 헬퍼
    // [UPDATED] 이제는 TTS 시작/종료에 따른 STT 제어가 자동으로 되므로,
    // 단순히 speak만 호출하면 된다.
    func speakQuestion(_ text: String) {
        // 인터뷰 준비만 되었는지 확인
        guard isReady else {
            errorMessage = "面接準備がまだです。"
            return
        }
        tts.speak(text)
    }

    func stopSpeaking() {
        tts.stop()
    }
}
