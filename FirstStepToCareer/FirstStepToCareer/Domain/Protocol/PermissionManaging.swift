//
//  PermissionManaging.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

/// 권한 확인/요청을 위한 최소한의 프로토콜 (비동기 호출 위주)
public protocol PermissionManaging: Sendable {
    // Camera
    func cameraStatus() -> AppPermissionStatus
    func requestCamera() async -> Bool

    // Microphone (iOS 17+)
    func microphoneStatus() -> AppPermissionStatus
    func requestMicrophone() async -> Bool

    // Speech (STT)
    func speechStatus() -> AppPermissionStatus
    func requestSpeech() async -> Bool

    /// 카메라/마이크/음성인식 요청을 병렬로 수행
    func requestCameraMicSpeech() async -> (camera: Bool, mic: Bool, speech: Bool)
}
