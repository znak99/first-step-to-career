//
//  AppPermissionStatus.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

enum AppPermissionStatus: Sendable {
    // 허용, 거부, 기기나 OS레벨 제한, 권한 요청 전
    case authorized, denied, restricted, notDetermined
}
