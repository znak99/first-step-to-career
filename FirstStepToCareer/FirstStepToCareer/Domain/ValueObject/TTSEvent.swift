//
//  TTSEvent.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

// MARK: - 얇은 이벤트 타입
/// 오케스트레이터가 "언제 STT로 넘어가야 하는지"만 알면 되도록 최소한으로 유지.
public enum TTSEvent: Sendable {
    case didStartUtterance
    case didFinishUtterance
    case didCancel
}
