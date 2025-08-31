//
//  AppPermissionStatus.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import Foundation

/// 앱 내부에서 권한 상태를 통일해서 다루기 위한 값 객체(VO)
public enum AppPermissionStatus: Sendable {
    case authorized
    case denied
    case restricted
    case notDetermined

    /// 편의 프로퍼티: 사용 가능 여부
    public var isAuthorized: Bool {
        if case .authorized = self { return true }
        return false
    }
}
