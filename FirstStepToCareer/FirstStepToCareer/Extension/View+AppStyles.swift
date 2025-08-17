//
//  View+AppStyles.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

extension View {
    // 앱의 캡션 텍스트의 스타일
    func appCaptionStyle() -> some View {
        modifier(AppCaptionStyle())
    }
}
