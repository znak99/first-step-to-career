//
//  CameraPreview.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI
@preconcurrency import AVFoundation

// AVCaptureVideoPreviewLayer를 담는 UIView
final class PreviewView: UIView {
    override static var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
            fatalError("PreviewView.layer is not AVCaptureVideoPreviewLayer")
        }
        return layer
    }

    // 작은 점 레이어
    private let dotLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.lineWidth = 2
        l.fillColor = UIColor.systemBlue.withAlphaComponent(0.15).cgColor
        l.strokeColor = UIColor.systemBlue.cgColor
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(dotLayer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(dotLayer)
    }

    /// 캡처 디바이스 좌표(0~1, 원점: 좌상) → 레이어 좌표로 변환해 점을 그림
    func drawDot(at devicePoint: CGPoint?, radius: CGFloat = 8) {
        guard let devicePoint else {
            dotLayer.path = nil
            return
        }
        let layerPoint = videoPreviewLayer.layerPointConverted(fromCaptureDevicePoint: devicePoint)
        let path = UIBezierPath(ovalIn: CGRect(x: layerPoint.x - radius,
                                               y: layerPoint.y - radius,
                                               width: radius * 2,
                                               height: radius * 2))
        dotLayer.path = path.cgPath
    }
}

// SwiftUI 래퍼
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    var gazeDevicePoint: CGPoint?

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        if let conn = view.videoPreviewLayer.connection {
            if #available(iOS 17.0, *) {
                conn.videoRotationAngle = 90   // 세로
            }
            conn.automaticallyAdjustsVideoMirroring = true
            if conn.isVideoMirroringSupported { conn.isVideoMirrored = true }
        }
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.drawDot(at: gazeDevicePoint, radius: 8)
    }
}

