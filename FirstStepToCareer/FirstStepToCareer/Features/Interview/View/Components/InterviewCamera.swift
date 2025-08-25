//
//  InterviewCamera.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/26.
//

import SwiftUI
import AVFoundation

struct InterviewCamera: View {
    // MARK: - Properties
    let session: AVCaptureSession
    let width: Double
    let height: Double
    @Binding var isRunning: Bool
    
    // MARK: - Body
    var body: some View {
        CameraPreview(session: session)
            .frame(width: isRunning ? width / 3 : width,
                   height: isRunning ? height / 4 : height)
            .clipShape(
                isRunning
                ? RoundedRectangle(cornerRadius: ACLayout.Radius.large, style: .continuous)
                : RoundedRectangle(cornerRadius: 0)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(
                isRunning
                ? ACLayout.Padding.large
                : 0
            )
    }
}

#Preview {
    GeometryReader { proxy in
        InterviewCamera(session: .init(),
                        width: proxy.size.width,
                        height: proxy.size.height,
                        isRunning: .constant(true))
    }
}
