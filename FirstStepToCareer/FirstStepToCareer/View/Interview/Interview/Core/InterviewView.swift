//
//  InterviewView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

struct InterviewView: View {
    @StateObject private var camera = CameraService()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CameraPreview(session: camera.session, gazeDevicePoint: camera.gazeDevicePoint)
                .ignoresSafeArea()
        }
        .task {
            do {
                try await camera.configureIfNeeded()
                await camera.start()
            } catch {
                // 권한 거부/디바이스 없음 등 최소한의 에러 처리
                print("Camera error:", error)
            }
        }
        .onDisappear {
            camera.stop()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        dismiss()
                    },
                    label: {
                        Image(systemName: SFSymbolsIcon.chevronLeft)
                            .foregroundStyle(Color.white)
                    }
                )
            }
        }
    }
}

#Preview {
    InterviewView()
}
