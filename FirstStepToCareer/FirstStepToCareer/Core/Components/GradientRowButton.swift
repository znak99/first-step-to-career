//
//  GradientNavigationButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct GradientRowButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon {
                    Image(icon)
                        .resizable()
                        .extraSmallFrame(alignment: .center)
                }
                Text(title)
                    .font(.custom(ACFont.Weight.semiBold,
                                  size: ACFont.Size.small,
                                  relativeTo: .subheadline))
                    .foregroundStyle(ACColor.Font.white)
                Spacer()
                Image(ACIcon.Vector.angleRightWhite)
                    .resizable()
                    .scaledToFit()
                    .extraSmallFrame(alignment: .center)
            }
            .padding(ACLayout.Padding.small)
            .background(
                LinearGradient(
                    colors: [
                        ACColor.Brand.GradientStart,
                        ACColor.Brand.GradientEnd
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
        }
        .tapScaleEffect()
        .padding(.top, ACLayout.Padding.small)
    }
}
