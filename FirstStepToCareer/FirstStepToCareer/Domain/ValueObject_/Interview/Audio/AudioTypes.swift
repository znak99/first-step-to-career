//
//  AudioTypes.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

enum AudioOwner: Sendable {
    case stt, tts
}

struct AudioFocusToken: Sendable {
    let id: UUID = .init()
}

enum AudioRoute: Sendable {
    case speaker, earpiece, bluetooth
}
