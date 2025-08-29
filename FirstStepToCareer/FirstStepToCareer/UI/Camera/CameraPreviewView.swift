//
//  CameraPreviewView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/29.
//

import AVFoundation
import UIKit

/// UIKit 뷰 위에 카메라 영상을 그리는 아주 작은 뷰입니다.
/// - 프레임이 바뀌면 레이어 크기만 맞춥니다.
final class CameraPreviewView: UIView {
    private let previewLayer = AVCaptureVideoPreviewLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }

    /// 세션을 붙입니다. (메인 스레드에서 안전하게 처리)
    func attach(session: AVCaptureSession) {
        if Thread.isMainThread {
            previewLayer.session = session
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.previewLayer.session = session
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}
