//
//  HeadDirection.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

/// 화면을 기준으로 고개가 어느 정도 돌아갔는지 간단히 담는 값입니다.
/// yaw, roll은 도(degree) 단위입니다. (양수/음수 방향은 Vision의 기본 기준을 따릅니다)
public struct FaceDirection: Sendable, Equatable {
    public let yaw: Double
    public let roll: Double
    public init(yaw: Double, roll: Double) {
        self.yaw = yaw
        self.roll = roll
    }
}
