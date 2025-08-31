//
//  STTEvent.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

// MARK: - 이벤트
public enum STTEvent: Sendable {
    case didStart
    case didFinish
    case didCancel
    case didSilenceTimeout   // dBFS 기반 무음 지속
    case didFail
}
