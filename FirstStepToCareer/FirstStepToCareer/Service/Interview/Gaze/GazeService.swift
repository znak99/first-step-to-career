//
//  GazeService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation
import CoreGraphics

@MainActor
final class GazeService: GazeTracking {

    private var outputHandler: (@Sendable (GazeVector) -> Void)?

    func setOutput(handler: @escaping @Sendable (GazeVector) -> Void) {
        self.outputHandler = handler
    }

    func update(landmarks: LandmarkResult) {
        // 간단한 예시: 왼/오른쪽 눈 중앙점 차이를 기준으로 시선 추정
        // 실제론 pupil/eye corner 위치 등을 활용 가능
        guard landmarks.points.count > 10 else { return }

        // 여기서는 x, y 평균값으로 간략화
        let avgX = landmarks.points.map { $0.x }.reduce(0, +) / CGFloat(landmarks.points.count)
        let avgY = landmarks.points.map { $0.y }.reduce(0, +) / CGFloat(landmarks.points.count)

        // 정면 비율 계산(중심 근처일수록 높음) → 0~1 클램핑
        let center = CGPoint(x: 0.5, y: 0.5)
        let dist = hypot(avgX - center.x, avgY - center.y)
        let onTarget = max(0, 1 - dist * 2) // 거리 멀수록 0에 가까움

        let vector = GazeVector(x: avgX, y: avgY, onTargetRatio: Double(onTarget))
        outputHandler?(vector)
    }
}
