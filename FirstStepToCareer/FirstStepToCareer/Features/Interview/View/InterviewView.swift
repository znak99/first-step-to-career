//
//  InterviewView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

struct InterviewView: View {
    @StateObject private var vm: InterviewViewModel = .init()
    @StateObject private var cameraVM: CameraViewModel = .init()
    @EnvironmentObject private var nc: NavigationController

    var body: some View {
        ZStack {
            // === Background
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            // === Camera
            CameraView(vm: cameraVM)
            
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
                        HStack {
                            Image(ACIcon.Vector.checkSquareGreen)
                                .resizable()
                                .scaledToFit()
                                .extraSmallFrame(alignment: .center)
                            Text("カメラ及びマイクを確認します！")
                                .appCaptionStyle()
                        }
                        HStack(alignment: .center) {
                            Image(ACIcon.Vector.speechBlack)
                                .resizable()
                                .scaledToFit()
                                .smallFrame(alignment: .center)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            Text("何でも喋ってください！")
                                .font(.custom(ACFont.Weight.regular, size: ACFont.Size.small))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                        }
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
                    Text("問題なければ面接を始めましょう！")
                        .appCaptionStyle()
                    GradientRowButton(title: "模擬面接開始", icon: ACIcon.Vector.selfieWhite) {
                        
                    }
                }
                .padding(.bottom, ACLayout.Padding.medium)
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InterviewView()
}
