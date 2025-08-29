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
    
    // 상태변수
    @State private var isCameraRunning = false
    var body: some View {
        ZStack {
            CameraPreview(session: cameraService.session)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
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
            .padding()
        }
        .onAppear {
            Task {
                try cameraService.prepareSession()
                cameraService.start()
                self.isCameraRunning = true
            }
        }
    }
}

#Preview {
    ServiceTestView()
}
