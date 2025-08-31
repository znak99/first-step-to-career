//
//  AudioClient.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

/// 오디오를 쓰는 대상 (내 앱에서는 TTS 또는 STT 둘뿐)
public enum AudioClient: Sendable {
    case tts
    case stt
}
