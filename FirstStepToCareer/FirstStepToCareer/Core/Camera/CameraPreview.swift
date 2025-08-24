//
//  CameraPreview.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import UIKit
import AVFoundation
import SwiftUI

// MARK: - CameraPreview (SwiftUI)
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    // MARK: UIViewRepresentable
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.attach(session: session)
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        if uiView.layer.sublayers?.contains(where: { $0 === uiView.layer.sublayers?.first }) == true {
            // 필요하다면 갱신 처리
        }
        uiView.attach(session: session)
    }
}
