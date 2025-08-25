//
//  InterviewView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

struct InterviewView: View {
    // MARK: - Properties
    @StateObject private var vm: InterviewViewModel = .init()
    @EnvironmentObject private var nc: NavigationController
    @EnvironmentObject private var interviewEngine: InterviewEngine
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // === Background
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            // === Camera
            CameraPreview(session: interviewEngine.cameraSession)
                            .ignoresSafeArea()
            
            // === Content
            VStack {
                InterviewViewTopBarExitButton {
                    vm.exitButtonTapped {
                        EntryKitPresenter.shared.showConfirmExit(
                            onConfirm: {
                                nc.path.removeAll()
                            },
                            onCancel: {
                                
                            }
                        )
                    }
                }
                if vm.isInterviewStarted {
                    VStack {
                        
                    }
                } else {
                    VStack {
                        InterviewViewPreparingHeader(transcript: interviewEngine.transcript)
                    }
                    .padding(ACLayout.Padding.medium)
                    .background {
                        ACColor.Font.white.opacity(0.7)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
                    .overlay {
                        RoundedRectangle(cornerRadius: ACLayout.Radius.medium)
                            .stroke(ACColor.Font.white, lineWidth: 1)
                    }
                }
                Spacer()
                AppSection {
                    if let errorMessage = interviewEngine.errorMessage {
                        Text(errorMessage)
                            .appCaptionStyle()
                            .foregroundStyle(ACColor.Status.error)
                            .padding(.vertical, ACLayout.Padding.extraSmall)
                    }
                    Text("問題なければ面接を始めましょう！")
                        .appCaptionStyle()
                    GradientRowButton(title: "模擬面接開始", icon: ACIcon.Vector.selfieWhite) {
                        vm.startButtonTapped {
                            
                        }
                    }
                }
                .padding(.bottom, ACLayout.Padding.medium)
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            interviewEngine.start()
        }
    }
}

#Preview {
    InterviewView()
}
