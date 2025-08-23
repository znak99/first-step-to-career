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
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            CameraPreview(session: camera.session)
                .ignoresSafeArea()
            VStack {
                Spacer()
                AppSection {
                    Text("カメラとマイクを確認します\n問題なければ下のボタンを押して模擬面接を始めましょう！")
                        .appCaptionStyle()
                    Button(
                        action: {
                            
                        },
                        label: {
                            Text("準備完了！")
                                .font(.custom(Font.appSemiBold, size: 16))
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                        }
                    )
                    .padding(8)
                    .background {
                        LinearGradient(
                            colors: [
                                ACColor.Brand.GradientStart,
                                ACColor.Brand.GradientEnd,
                            ],
                            startPoint: .top,
                            endPoint: .bottom)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
                }
            }
            .padding(.horizontal, 16)
        }
        .task {
            do {
                try await camera.configureIfNeeded()
                await camera.start()
            } catch {
                print("Camera error:", error)
            }
        }
        .onDisappear {
            camera.stop()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InterviewView()
}
