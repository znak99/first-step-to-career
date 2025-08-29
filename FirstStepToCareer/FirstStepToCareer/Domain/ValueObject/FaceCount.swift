//
//  FaceCount.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

/// 얼굴 개수 표현 (값만 필요하므로 아주 단순하게)
public enum FaceCount: Sendable, Equatable {
    case none    // 0명
    case one     // 1명
    case many    // 2명 이상
}
