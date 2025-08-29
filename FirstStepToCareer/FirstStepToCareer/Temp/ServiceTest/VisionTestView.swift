//
//  VisionTestView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import SwiftUI

struct VisionTestView: View {
    // 카메라 서비스
    let camera: CameraService = .init()
    // 얼굴 검출 서비스
    let faceDetection: FaceDetectionService = .init()
    
    // 상태변수
    @State private var isCameraRunning = false
    @State private var faceDetected = ""
    @State private var isDirectionRunning = false
    @State private var faceYaw = ""
    @State private var faceRoll = ""
    @State private var facePitch = ""
    var body: some View {
        ZStack {
            CameraPreview(session: camera.session)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Text(faceDetected)
                        .padding(4)
                        .background(.white)
                    Button(isCameraRunning ? "Camera Pause" : "Camera Resume") {
                        if isCameraRunning {
                            camera.pause()
                        } else {
                            camera.start()
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
                for await result in faceDetection.results {
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
                try? camera.prepareSession()
                camera.start()
                isCameraRunning = true
                faceDetection.prepare()
                faceDetection.start()
            }
            
            Task { @MainActor in
                for await frame in camera.frames {
                    faceDetection.process(frame.buffer)
                }
            }
        }
        .onDisappear {
            camera.shutdown()
            faceDetection.shutdown()
            isCameraRunning = false
        }
    }
}

#Preview {
    VisionTestView()
}
