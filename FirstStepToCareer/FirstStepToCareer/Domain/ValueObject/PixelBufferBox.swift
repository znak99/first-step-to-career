//
//  PixelBufferBox.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

// CVPixelBuffer를 안전하게 옮기기 위한 아주 작은 상자
// 다른 건 안 하고, 버퍼만 담는다.
import CoreVideo

public struct PixelBufferBox: @unchecked Sendable {
    public let buffer: CVPixelBuffer
    public init(_ buffer: CVPixelBuffer) { self.buffer = buffer }
}
