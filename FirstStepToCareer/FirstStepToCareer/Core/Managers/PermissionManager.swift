//
//  PermissionManager.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import AVFoundation
import AVFAudio
import Photos

struct PermissionManager {
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
            return await withCheckedContinuation { cont in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    cont.resume(returning: granted)
                }
            }
        }
    }

    // MARK: - Microphone
    func microphoneStatus() -> AppPermissionStatus {
        if #available(iOS 17.0, *) {
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
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
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
    }

    func requestMicrophone() async -> Bool {
        switch microphoneStatus() {
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            if #available(iOS 17.0, *) {
                return await withCheckedContinuation { cont in
                    AVAudioApplication.requestRecordPermission { granted in
                        cont.resume(returning: granted)
                    }
                }
            } else {
                return await withCheckedContinuation { cont in
                    AVAudioSession.sharedInstance().requestRecordPermission { granted in
                        cont.resume(returning: granted)
                    }
                }
            }
        }
    }
}
