//
//  CameraViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

@MainActor
final class CameraViewModel: ObservableObject {
    // MARK: - Properties
    let camera = CameraService()
    private let permission = PermissionManager()
    @Published var state: State = .idle
    
    deinit { camera.stopRunning() }
    
    enum State {
        case idle
        case requesting
        case ready
        case denied
    }

    func prepare() {
        state = .requesting
        Task {
            let granted = await permission.requestCamera()
            if granted {
                camera.configure(.init(preset: .high))
                camera.startRunning()
                state = .ready
            } else {
                state = .denied
            }
        }
    }

    func start() {
        camera.startRunning()
    }

    func stop() {
        camera.stopRunning()
    }
    
    func sceneChanged(newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            if state == .ready {
                start()
            }
        case .background, .inactive:
            stop()
        @unknown default:
            break
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
