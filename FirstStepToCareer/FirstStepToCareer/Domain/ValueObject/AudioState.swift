//
//  AudioState.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

/// 오디오 세션의 단순 상태
public enum AudioState: Sendable, Equatable {
    case idle                 // 아무도 점유하지 않음
    case owning(AudioClient)  // 한 대상이 점유 중
    case paused(AudioClient)  // 외부 요인(전화 등)으로 잠시 멈춤
}
