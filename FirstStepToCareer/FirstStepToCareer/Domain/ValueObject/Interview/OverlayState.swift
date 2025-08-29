//
//  OverlayState.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation

struct OverlayState: Sendable {
    /// 얼굴 바운딩 박스(정규화 좌표, 0~1)
    var faceBoundingBox: CGRect?
    /// 시선 벡터 및 on-target 비율(0~1)
    var gazeX: Double?
    var gazeY: Double?
    var onTargetRatio: Double?
    /// 표정 추정(positive/neutral/negative/uncertain)
    enum Emotion: String, Sendable { case positive, neutral, negative, uncertain }
    var emotion: Emotion?
}
