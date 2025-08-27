//
//  PermissionManaging.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

protocol PermissionManaging: Sendable {
    func cameraStatus() -> AppPermissionStatus
    func requestCamera() async -> Bool
    func microphoneStatus() -> AppPermissionStatus
    func requestMicrophone() async -> Bool
    func speechStatus() -> AppPermissionStatus
    func requestSpeech() async -> Bool
}
