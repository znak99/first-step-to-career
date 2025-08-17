//
//  View+TapScaleEffect.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

extension View {
    /// - Parameters:
    ///   - scale: 눌렸을 때 스케일(기본 0.85)
    ///   - downDuration: 눌릴 때 속도(기본 0.08s)
    ///   - upDuration: 복귀 시간(기본 0.30s)
    ///   - upBounce: 복귀 바운스 양(기본 0.08)
    ///   - haptic: 탭-다운 시 햅틱 사용 여부(기본 false)
    func tapScaleEffect(
        _ scale: CGFloat = 0.95,
        downDuration: Double = 0.08,
        upDuration: Double = 0.30,
        upBounce: Double = 0.08,
        haptic: Bool = false
    ) -> some View {
        modifier(TapScaleEffect(
            scale: scale,
            downDuration: downDuration,
            upDuration: upDuration,
            upBounce: upBounce,
            haptic: haptic
        ))
    }
}
