//
//  CameraView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct CameraView: View {
    // MARK: - Properties
    @ObservedObject var vm: CameraViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Body
    var body: some View {
        ZStack {
            switch vm.state {
            case .ready:
                CameraPreview(session: vm.camera.session)
                    .ignoresSafeArea()
            case .requesting:
                ProgressView("カメラの権限を確認中…")
                    .padding()
                
            case .denied:
                VStack(spacing: 12) {
                    Text("カメラへのアクセスが許可されていません。")
                        .font(.headline)
                    Text("設定 > 就活一歩 > カメラ を有効にしてください。")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Button("設定を開く") { vm.openSettings() }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
                
            case .idle:
                EmptyView()
            }
        }
        .task {
            vm.prepare()
            vm.start()
        }
        .onDisappear {
            vm.stop()
        }
        .onChange(of: scenePhase) { _, newPhase in
            vm.sceneChanged(newPhase: newPhase)
        }
    }
}

#Preview {
    CameraView(vm: CameraViewModel())
}
