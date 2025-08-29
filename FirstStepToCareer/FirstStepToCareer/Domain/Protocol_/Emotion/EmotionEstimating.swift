//
//  EmotionEstimating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation
import CoreMedia

@MainActor
protocol EmotionEstimating: Sendable {
    func estimate(from crop: CVPixelBuffer)
    func setOutput(handler: @escaping @Sendable (EmotionResult) -> Void)
}
