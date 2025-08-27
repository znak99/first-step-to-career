//
//  AudioManaging.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import AVFoundation

protocol AudioManaging: Sendable {
    func configureSession(for interview: InterviewContext) throws
    func requestFocus(_ owner: AudioOwner) throws -> AudioFocusToken?
    func abandonFocus(_ token: AudioFocusToken)
    func pauseAll()
    func resumeIfNeeded()
    func setRoute(_ route: AudioRoute) throws
    func setPreferredIO(sampleRate: Double?, bufferDuration: TimeInterval?) throws
    var onInterruption: (@Sendable (Bool) -> Void)? { get set } // true = began
    var onRouteChange: (@Sendable () -> Void)? { get set }
}
