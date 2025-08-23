//
//  CameraPreview.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI
@preconcurrency import AVFoundation
import UIKit

/// AVCaptureVideoPreviewLayer를 담는 UIView
final class PreviewView: UIView {
    // final class에서는 static override
    override static var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
            fatalError("PreviewView.layer is not AVCaptureVideoPreviewLayer")
        }
        return layer
    }
}

/// SwiftUI 래퍼
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let v = PreviewView()
        v.videoPreviewLayer.session = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill

        if let conn = v.videoPreviewLayer.connection {
            if #available(iOS 17.0, *) {
                conn.videoRotationAngle = 90 // 세로
            }
            // 전면 카메라는 보통 셀피 미러링을 선호
            conn.automaticallyAdjustsVideoMirroring = true
            if conn.isVideoMirroringSupported { conn.isVideoMirrored = true }
        }
        return v
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        // 프리뷰는 세션만 유지하면 됨
    }
}
