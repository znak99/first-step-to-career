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
    @EnvironmentObject private var interviewOrchestrator: InterviewOrchestrator
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // === Background
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            // === Camera
            GeometryReader { proxy in
                VStack {
                    if vm.isRunning {
                        InterviewViewTopBarExitButton {}
                            .hidden()
                    }
//                    InterviewCamera(
//                        session: interviewOrchestrator.cameraSession,
//                        width: proxy.size.width,
//                        height: proxy.size.height,
//                        isRunning: $vm.isRunning)
                }
            }
            .ignoresSafeArea(vm.isRunning ? .keyboard : .all)
            
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
                if vm.isRunning {
                    VStack {
                        
                    }
                } else {
                    InterviewViewPreparingHeader(transcript: "interviewOrchestrator.transcript") {
                        vm.speakButtonTapped {
                            Task {
                                await interviewOrchestrator.speak("カメラ及びマイクを確認します！")
                            }
                        }
                    }
                }
                Spacer()
                AppSection {
//                    if let errorMessage = interviewOrchestrator.errorMessage {
//                        Text(errorMessage)
//                            .appCaptionStyle()
//                            .foregroundStyle(ACColor.Status.error)
//                            .padding(.vertical, ACLayout.Padding.extraSmall)
//                    }
                    Text("問題なければ面接を始めましょう！")
                        .appCaptionStyle()
                    GradientRowButton(title: "模擬面接開始", icon: ACIcon.Vector.selfieWhite) {
                        withAnimation(.easeIn) {
                            vm.startButtonTapped {
                                
                            }
                        }
                    }
                }
                .padding(.bottom, ACLayout.Padding.medium)
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            
        }
    }
}

#Preview {
    InterviewView()
}
