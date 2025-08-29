//
//  AudioSessionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import AVFoundation

@MainActor
final class AudioSessionService: AudioManaging {

    private let session = AVAudioSession.sharedInstance()
    private var focusOwner: AudioOwner? = nil
    private var focusToken: AudioFocusToken? = nil

    var onInterruption: (@Sendable (Bool) -> Void)?
    var onRouteChange: (@Sendable () -> Void)?

    func configureSession(for interview: InterviewContext) throws {
        try session.setCategory(.playAndRecord,
                                mode: .voiceChat,
                                options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true, options: [])
    }

    func requestFocus(_ owner: AudioOwner) throws -> AudioFocusToken? {
        if focusOwner == .tts, owner == .stt { return nil }
        focusOwner = owner
        let token = AudioFocusToken()
        focusToken = token
        return token
    }

    func abandonFocus(_ token: AudioFocusToken) {
        guard token.id == focusToken?.id else { return }
        focusOwner = nil
        focusToken = nil
    }

    func pauseAll() {
        try? session.setActive(false, options: [.notifyOthersOnDeactivation])
    }

    func resumeIfNeeded() {
        try? session.setActive(true, options: [])
    }

    func setRoute(_ route: AudioRoute) throws {
        switch route {
        case .speaker:  try session.overrideOutputAudioPort(.speaker)
        case .earpiece: try session.overrideOutputAudioPort(.none)
        case .bluetooth: break
        }
    }

    func setPreferredIO(sampleRate: Double?, bufferDuration: TimeInterval?) throws {
        if let rate = sampleRate { try session.setPreferredSampleRate(rate) }
        if let dur = bufferDuration { try session.setPreferredIOBufferDuration(dur) }
    }

    init() {
        let center = NotificationCenter.default

        center.addObserver(forName: AVAudioSession.interruptionNotification,
                           object: session,
                           queue: .main) { [weak self] noti in
            guard let self else { return }
            let typeRaw = noti.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
            guard let type = AVAudioSession.InterruptionType(rawValue: typeRaw ?? 0) else { return }

            switch type {
            case .began:
                // ⬇️ 메인 액터로 홉
                Task { @MainActor in self.onInterruption?(true) }
            case .ended:
                Task { @MainActor in self.onInterruption?(false) }
            @unknown default:
                break
            }
        }

        center.addObserver(forName: AVAudioSession.routeChangeNotification,
                           object: session,
                           queue: .main) { [weak self] _ in
            guard let self else { return }
            // ⬇️ 메인 액터로 홉
            Task { @MainActor in self.onRouteChange?() }
        }
    }

}
