//
//  PermissionManager.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import AVFoundation
import Photos
import CoreLocation
import UserNotifications

final class PermissionManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    // MARK: - Camera
    func requestCamera(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        default:
            completion(false)
        }
    }

    // MARK: - Microphone
    func requestMicrophone(completion: @escaping (Bool) -> Void) {
        let permission = AVAudioApplication.shared.recordPermission
        switch permission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        @unknown default:
            completion(false)
        }
    }
}

