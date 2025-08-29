//
//  HeadDirection.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

// MARK: - 값 객체
/// 얼굴 방향(라디안 단위). pitch는 TrueDepth가 없으면 nil 입니다.
public struct HeadDirection: Sendable, Equatable {
    public let yaw: Float      // 좌우 회전(+면 오른쪽으로 고개)
    public let roll: Float     // 기울기(+면 시계방향 기울임)
    public let pitch: Float?   // 위/아래(TrueDepth 가능 시만 존재)

    public init(yaw: Float, roll: Float, pitch: Float?) {
        self.yaw = yaw
        self.roll = roll
        self.pitch = pitch
    }
}
