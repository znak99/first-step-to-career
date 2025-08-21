//
//  GradientNavigationButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct GradientNavigationButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon {
                    Image(icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text(title)
                    .font(.custom(Font.appSemiBold, size: 16))
                Spacer()
                Image(systemName: SFSymbolsIcon.chevronRight)
            }
            .padding(8)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [Color.appMainGradientStart, Color.appMainGradientEnd],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
        }
        .tapScaleEffect()
    }
}
