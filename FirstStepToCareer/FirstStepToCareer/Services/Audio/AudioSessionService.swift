//
//  AudioSessionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation

/// 세션 설정 실패(단일 에러로 단순화)
public enum AudioSessionError: Error {
    case setupFailed
}

/// 오디오 세션을 실제로 제어하는 구현체(얇은 서비스).
/// - 목적: TTS/STT가 동시에 오디오를 쓰지 않게 "한 번에 하나"만 점유.
/// - 설계: 카테고리는 .playAndRecord 고정, 모드만 TTS/STT에 맞게 전환.
/// - 옵션: .defaultToSpeaker, .allowBluetooth (필요 시 변경 가능)
public actor AudioSessionService: AudioSessionControlling {

    // MARK: - Private
    private let session = AVAudioSession.sharedInstance()
    private var current: AudioState = .idle
    private var tokens: [NSObjectProtocol] = []

    // MARK: - Public
    public init() {}

    public var state: AudioState { current }

    public func prepare() async throws {
        do {
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            try? session.overrideOutputAudioPort(.speaker)
            listenNotifications() // 중단/경로변경 감지 (최소)
        } catch {
            throw AudioSessionError.setupFailed
        }
    }

    @discardableResult
    public func acquire(_ client: AudioClient) async -> Bool {
        // 이미 같은 클라이언트가 점유 중이면 그대로 성공
        if case .owning(client) = current { return true }

        // 호출 순서대로 즉시 전환
        current = .owning(client)
        do {
            try applyMode(for: client)
            try session.setActive(true) // 전환 시 재활성화로 글리치 최소화
            return true
        } catch {
            // 실패 시 상태 원복
            current = .idle
            return false
        }
    }

    public func release(_ client: AudioClient) async {
        // 해당 클라이언트가 점유 중일 때만 idle로
        if case .owning(client) = current {
            current = .idle
            // 다음 단계 전환(TTS→STT 등)을 빠르게 하기 위해 세션은 비활성화하지 않습니다.
        } else if case .paused(client) = current {
            current = .idle
        }
    }

    public func pauseAll() async {
        if case .owning(let owner) = current {
            current = .paused(owner)
        }
        // 외부 중단 동안은 비활성화
        _ = try? session.setActive(false)
    }

    public func resumeIfNeeded() async {
        guard case .paused(let owner) = current else { return }
        current = .owning(owner)
        do {
            try applyMode(for: owner)
            try session.setActive(true)
        } catch {
            current = .idle
        }
    }

    public func shutdown() async {
        // 알림 해제
        for t in tokens { NotificationCenter.default.removeObserver(t) }
        tokens.removeAll()

        _ = try? session.setActive(false)
        current = .idle
    }

    // MARK: - Helpers

    /// TTS/STT에 맞는 모드만 가볍게 전환
    private func applyMode(for client: AudioClient) throws {
        switch client {
        case .tts:
            // ✅ 미디어 경로: 스피커 크게, 하드웨어 볼륨도 미디어 볼륨 트랙
            try session.setCategory(.playback, options: [])   // 필요시 [.duckOthers] 추가 가능
            try session.setMode(.default)                     // 또는 .spokenAudio도 OK (취향)
            try session.setActive(true)
            try? session.overrideOutputAudioPort(.speaker)    // 안전빵

        case .stt:
            // ✅ 녹음 경로: 보이스 프로세싱 유리
            try session.setCategory(.playAndRecord, options: [.allowBluetooth, .defaultToSpeaker])
            try session.setMode(.voiceChat)                   // 음성 인식에 유리
            try session.setActive(true)
            // STT에선 override 불필요 (수화기 라우트가 더 자연스러울 때도 있음)
        }
    }

    /// 시스템 중단/경로변경 알림을 받아 최소 대응
    private func listenNotifications() {
        let nc = NotificationCenter.default

        let t1 = nc.addObserver(forName: AVAudioSession.interruptionNotification,
                                object: nil,
                                queue: nil) { [self] note in
            Task { await self.handleInterruption(note) }
        }

        let t2 = nc.addObserver(forName: AVAudioSession.routeChangeNotification,
                                object: nil,
                                queue: nil) { [self] note in
            Task { await self.handleRouteChange(note) }
        }

        tokens.append(contentsOf: [t1, t2])
    }

    private func handleInterruption(_ note: Notification) async {
        guard
            let info = note.userInfo,
            let rawType = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }

        switch type {
        case .began:
            await pauseAll()

        case .ended:
            let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            let opts = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if opts.contains(.shouldResume) {
                await resumeIfNeeded()
            }
        @unknown default:
            break
        }
    }

    private func handleRouteChange(_ note: Notification) async {
        // 이어폰 탈착 등 경로가 바뀌면, 현재 점유자 기준으로 모드만 다시 적용
        switch current {
        case .owning(let owner), .paused(let owner):
            _ = try? applyMode(for: owner)
            if owner == .tts { try?session.overrideOutputAudioPort(.speaker) }
        case .idle:
            break
        }
    }
}
