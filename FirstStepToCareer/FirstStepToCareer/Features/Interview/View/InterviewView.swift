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
                HStack {
                    Spacer()
                    Button(
                        action: {
                            vm.exitButtonTapped {
                                EntryKitPresenter.shared.showConfirmExit(
                                    onConfirm: {
                                        nc.path.removeAll()
                                    },
                                    onCancel: {
                                        
                                    }
                                )
                            }
                        },
                        label: {
                            Image(ACIcon.Vector.xWhite)
                                .resizable()
                                .scaledToFit()
                                .mediumFrame(alignment: .center)
                        }
                    )
                }
                
                Spacer()
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InterviewView()
}
