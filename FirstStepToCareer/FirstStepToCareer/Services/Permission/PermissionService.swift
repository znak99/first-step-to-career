//
//  PermissionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import AVFoundation
import Speech

struct PermissionService: PermissionManaging {
    // MARK: - Camera
    func cameraStatus() -> AppPermissionStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }

    func requestCamera() async -> Bool {
        switch cameraStatus() {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return await awaitBool { cont in
                AVCaptureDevice.requestAccess(for: .video) { cont($0) }
            }
        }
    }

    // MARK: - Microphone (iOS 17+)
    func microphoneStatus() -> AppPermissionStatus {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            return .authorized
        case .denied:
            return .denied
        case .undetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }

    func requestMicrophone() async -> Bool {
        switch microphoneStatus() {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return await withCheckedContinuation { cont in
                AVAudioApplication.requestRecordPermission { granted in
                    cont.resume(returning: granted)
                }
            }
        }
    }

    // MARK: - Speech (STT)
    func speechStatus() -> AppPermissionStatus {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }

    func requestSpeech() async -> Bool {
        switch speechStatus() {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return await withCheckedContinuation { cont in
                SFSpeechRecognizer.requestAuthorization { status in
                    cont.resume(returning: status == .authorized)
                }
            }
        }
    }
}

extension PermissionService {
    // MARK: - Helper
    private func awaitBool(_ request: (@escaping (Bool) -> Void) -> Void) async -> Bool {
        await withCheckedContinuation { cont in request { cont.resume(returning: $0) } }
    }
    
    func requestCameraMicSpeech() async -> (camera: Bool, mic: Bool, speech: Bool) {
        async let cam = requestCamera()
        async let mic = requestMicrophone()
        async let sp  = requestSpeech()
        let result = await (cam, mic, sp)
        return result
    }
}
