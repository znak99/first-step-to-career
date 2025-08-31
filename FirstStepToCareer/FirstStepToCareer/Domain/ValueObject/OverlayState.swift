//
//  OverlayState.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//
import Foundation

/// 프리체크/러닝 화면의 오버레이(뷰에서 직접 그릴 수 있게 최소 상태만)
struct OverlayState: Sendable {
    /// 얼굴 바운딩 박스(정규화 좌표, 0~1)
    var faceBoundingBox: CGRect?
    var yaw: Float
    var roll: Float
    var transcript: String
}
