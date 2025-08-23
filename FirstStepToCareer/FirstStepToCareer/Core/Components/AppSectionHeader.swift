//
//  AppSectionHeader.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct AppSectionHeader: View {
    let icon: String
    let text: String
    var lottie: String?
    var body: some View {
        HStack(spacing: ACLayout.Spacing.small) {
            if let lottie {
                LottieView(name: lottie, loopMode: .playOnce)
                    .smallFrame(alignment: .center)
            } else {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .smallFrame(alignment: .center)
            }
            Text(text)
                .font(.custom(ACFont.Weight.regular, size: ACFont.Size.small, relativeTo: .subheadline))
                .foregroundStyle(ACColor.Font.black)
            Spacer()
        }
    }
}
