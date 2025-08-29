//
//  ServiceTestView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/29.
//

import SwiftUI

struct ServiceTestView: View {
    // 카메라 서비스
    let cameraService: CameraService = .init()
    // 얼굴 검출 서비스
    let faceDetectionService: FaceDetectionService = .init()
    
    // 상태변수
    @State private var isCameraRunning = false
    @State private var faceDetected = ""
    var body: some View {
        ZStack {
            CameraPreview(session: cameraService.session)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Text(faceDetected)
                        .padding(4)
                        .background(.white)
                    Button(isCameraRunning ? "Camera Pause" : "Camera Resume") {
                        if isCameraRunning {
                            cameraService.pause()
                        } else {
                            cameraService.start()
                        }
                        isCameraRunning.toggle()
                    }
                    .padding(4)
                    .background(.white)
                }
            }
            .padding()
            
        }
        .onAppear {
            Task {
                for await result in faceDetectionService.results {
                    switch result {
                    case .none:
                        self.faceDetected = "FACE: 0"
                    case .one:
                        self.faceDetected = "FACE: 1"
                    case .many:
                        self.faceDetected = "FACE: 2+"
                    }
                }
            }
            Task {
                try? cameraService.prepareSession()
                cameraService.start()
                isCameraRunning = true
            }
            faceDetectionService.prepare()
            faceDetectionService.start()
            
            Task { @MainActor in
                for await box in cameraService.frames {
                    faceDetectionService.process(box.buffer)
                }
            }
        }
        .onDisappear {
            cameraService.shutdown()
            faceDetectionService.shutdown()
            isCameraRunning = false
        }
    }
}

#Preview {
    ServiceTestView()
}

