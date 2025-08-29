//
//  CameraPreview.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/29.
//

import AVFoundation
import UIKit
import SwiftUI

/// SwiftUI에서 사용할 수 있는 최소 미리보기 래퍼입니다.
/// - `session`만 넘기면 화면에 출력됩니다.
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.attach(session: session)
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        // 세션 변경이 필요하면 여기서 다시 attach(session:) 호출
        // (이번 최소 구현에서는 변경 없음)
    }
}
