//
//  SmileResult.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

// MARK: - 외부에서 쓰기 쉬운 값(필요 최소한)
/**
 웃음 검출 결과.
 - isSmiling: 웃는 중인지
 - confidence: 0.0~1.0 사이 신뢰도(없으면 0)
 */
public struct SmileResult: Sendable, Equatable {
    public let isSmiling: Bool
    public let confidence: Float
    public init(isSmiling: Bool, confidence: Float) {
        self.isSmiling = isSmiling
        self.confidence = confidence
    }
}
