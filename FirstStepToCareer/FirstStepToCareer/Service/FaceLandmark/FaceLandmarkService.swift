//
//  FaceLandmarkService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation
import Vision
import CoreMedia
import CoreVideo
import CoreGraphics

@MainActor
final class FaceLandmarkService: FaceLandmarkDetecting {
    private let sequenceHandler = VNSequenceRequestHandler()
    private var outputHandler: (@Sendable (LandmarkResult) -> Void)?
    private var frameCounter = 0
    private var isProcessing = false
    private let sampleEveryNFrames: Int

    init(sampleEveryNFrames: Int = 2) {
        self.sampleEveryNFrames = max(1, sampleEveryNFrames)
    }

    func setOutput(handler: @escaping @Sendable (LandmarkResult) -> Void) {
        self.outputHandler = handler
    }

    func process(frame: CVPixelBuffer, at time: CMTime) {
        frameCounter &+= 1
        guard frameCounter % sampleEveryNFrames == 0 else { return }
        guard !isProcessing else { return }
        isProcessing = true
        defer { isProcessing = false }

        let req = VNDetectFaceLandmarksRequest()
        do {
            try sequenceHandler.perform([req], on: frame)
        } catch { return }

        guard
            let obs = (req.results)?.max(by: { $0.boundingBox.area < $1.boundingBox.area }),
            let lm = obs.landmarks
        else { return }

        let bbox = obs.boundingBox
        let points = Self.normalizedImagePoints(from: lm, in: bbox)
        let result = LandmarkResult(boundingBox: bbox, points: points)

        outputHandler?(result)
    }

    private static func normalizedImagePoints(from landmarks: VNFaceLandmarks2D,
                                              in bbox: CGRect) -> [CGPoint] {
        var all: [CGPoint] = []
        if let pts = landmarks.allPoints?.normalizedPoints {
            all.reserveCapacity(pts.count)
            for p in pts {
                let x = bbox.origin.x + bbox.size.width * CGFloat(p.x)
                let y = bbox.origin.y + bbox.size.height * CGFloat(p.y)
                all.append(CGPoint(x: x, y: y))
            }
            return all
        }
        return []
    }
}
