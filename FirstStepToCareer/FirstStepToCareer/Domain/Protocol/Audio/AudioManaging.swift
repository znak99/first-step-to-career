//
//  AudioManaging.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import AVFoundation

@MainActor
protocol AudioManaging: AnyObject, Sendable {
    func configureSession(for interview: InterviewContext) throws
    func requestFocus(_ owner: AudioOwner) throws -> AudioFocusToken?
    func abandonFocus(_ token: AudioFocusToken)

    func pauseAll()
    func resumeIfNeeded()

    func setRoute(_ route: AudioRoute) throws
    func setPreferredIO(sampleRate: Double?, bufferDuration: TimeInterval?) throws

    // 메인 액터에서 접근/설정되는 콜백
    var onInterruption: (@Sendable (Bool) -> Void)? { get set }
    var onRouteChange: (@Sendable () -> Void)? { get set }
}
