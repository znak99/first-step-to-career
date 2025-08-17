//
//  TapScaleEffect.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct TapScaleEffect: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled

    var scale: CGFloat
    var downDuration: Double
    var upDuration: Double
    var upBounce: Double
    var haptic: Bool

    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed && isEnabled ? scale : 1.0)
            // isPressed 변화시에만 감지 → 눌림(true)일 때만 햅틱, 아니면 nil 반환
            .sensoryFeedback(trigger: isPressed) { _, newValue in
                guard haptic, newValue else { return nil }
                return .impact(weight: .medium, intensity: 0.85)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard isEnabled, !isPressed else { return }
                        withAnimation(.snappy(duration: downDuration, extraBounce: 0)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.bouncy(duration: upDuration, extraBounce: upBounce)) {
                            isPressed = false
                        }
                    }
            )
    }
}
