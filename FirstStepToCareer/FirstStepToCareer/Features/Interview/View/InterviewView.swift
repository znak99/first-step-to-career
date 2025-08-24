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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // === Background
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            // === Camera
            CameraView(vm: cameraVM)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InterviewView()
}
