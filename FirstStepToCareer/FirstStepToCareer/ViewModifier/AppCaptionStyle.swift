//
//  AppCaptionStyle.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct AppCaptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(Font.appRegular, size: 12, relativeTo: .caption))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
