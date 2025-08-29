//
//  EmotionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation
import Vision
import CoreVideo
import CoreMedia

@MainActor
final class EmotionService: EmotionEstimating {

    private var outputHandler: (@Sendable (EmotionResult) -> Void)?
    private let request: VNClassifyImageRequest

    init() {
        // iOS 17+: Core ML 없이도 시스템 제공 "Scene/Emotion" 분류 모델 사용 가능
        self.request = VNClassifyImageRequest()
    }

    func setOutput(handler: @escaping @Sendable (EmotionResult) -> Void) {
        self.outputHandler = handler
    }

    func estimate(from crop: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: crop, orientation: .up)

        do {
            try handler.perform([request])
        } catch {
            return
        }

        guard let obs = request.results?.first else { return }
        // 예시: identifier가 "happy", "neutral", "angry" 같은 텍스트일 수 있음
        let id = obs.identifier.lowercased()
        let confidence = Double(obs.confidence)

        let category: EmotionResult.Category
        if id.contains("happy") {
            category = .positive
        } else if id.contains("neutral") {
            category = .neutral
        } else if id.contains("angry") || id.contains("sad") {
            category = .negative
        } else {
            category = .uncertain
        }

        let result = EmotionResult(category: category, confidence: confidence)
        outputHandler?(result)
    }
}
