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
            CameraPreview(session: camera.session)
            .ignoresSafeArea()
            .task {
                do {
                    try await camera.configureIfNeeded()
                    await camera.start()
                } catch {
                    print("Camera error:", error)
                }
            }
        }
        .onDisappear {
            camera.stop()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    InterviewView()
}
