//
//  ARKitTestView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import SwiftUI

struct ARKitTestView: View {
    // 얼굴 방향 검출 서비스
    let faceDirection: FaceDirectionService = .init()
    // 상태 변수
    @State private var faceYaw = ""
    @State private var faceRoll = ""
    @State private var facePitch = ""
    // 스트림 수집 작업 수명 관리
    @State private var resultTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                Text("yaw: \(faceYaw)")
                    .padding(4).background(.white).foregroundStyle(.black)
                Text("roll: \(faceRoll)")
                    .padding(4).background(.white).foregroundStyle(.black)
                Text("pitch: \(facePitch)")
                    .padding(4).background(.white).foregroundStyle(.black)
                Spacer()
            }
        }
        .onAppear {
            // 준비 → 얼굴 1명으로 간주 → 시작
            try? faceDirection.prepare()
            faceDirection.update(faceCount: .one)
            faceDirection.start()

            // 결과 스트림 수집
            resultTask = Task {
                for await dir in faceDirection.results {
                    await MainActor.run {
                        faceYaw = String(format: "%.2f", dir.yaw)
                        faceRoll = String(format: "%.2f", dir.roll)
                        if let p = dir.pitch {
                            facePitch = String(format: "%.2f", p)
                        } else {
                            facePitch = "-" // Vision 등 pitch 없음
                        }
                    }
                }
            }
        }
        .onDisappear {
            // 정리
            resultTask?.cancel(); resultTask = nil
            faceDirection.shutdown()
        }
    }
}

#Preview {
    ARKitTestView()
}
