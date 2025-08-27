//
//  EmotionEstimating.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation
import CoreMedia

protocol EmotionEstimating: Sendable {
    func estimate(from crop: CVPixelBuffer) async
    func setOutput(handler: @escaping @Sendable (EmotionResult) -> Void)
}
