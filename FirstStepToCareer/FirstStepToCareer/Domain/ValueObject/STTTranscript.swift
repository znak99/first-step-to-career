//
//  Untitled.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

// MARK: - ValueObject (partial/final 구분)
public struct STTTranscript: Sendable {
    public let text: String
    public let isFinal: Bool
}

