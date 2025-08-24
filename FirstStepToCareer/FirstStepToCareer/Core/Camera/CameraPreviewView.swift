//
//  CameraPreviewView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import UIKit
import AVFoundation
import SwiftUI

final class CameraPreviewView: UIView {
    // MARK: Properties
    private let videoPreviewLayer = AVCaptureVideoPreviewLayer()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: Setup
    private func commonInit() {
        videoPreviewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(videoPreviewLayer)
    }

    // MARK: Public Methods
    func attach(session: AVCaptureSession) {
        if Thread.isMainThread {
            videoPreviewLayer.session = session
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.videoPreviewLayer.session = session
            }
        }
    }

    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer.frame = bounds
    }
}
