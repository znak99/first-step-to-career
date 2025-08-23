//
//  ProgressRing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

struct ProgressRing: View {
    var progress: Double
    var thickness: CGFloat = 16
    var gradient: AngularGradient = .init(
        gradient: Gradient(colors: [.blue, .purple]),
        center: .center
    )
    var fontsize: CGFloat = 12

    var body: some View {
        ZStack {
            Circle()
                .stroke(.quinary, lineWidth: thickness)
            Circle()
                .trim(from: 0, to: progress * 0.1)
                .stroke(
                    gradient,
                    style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(90))

            HStack(spacing: 0) {
                Text(String(format: "%.1f%", progress))
                    .font(.custom(Font.appSemiBold, size: fontsize))
                Text("点")
                    .font(.custom(Font.appRegular, size: fontsize - 2))
            }
        }
        .contentShape(Circle())
        .animation(.spring(response: 0.5, dampingFraction: 0.3), value: progress)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Metric")
        .accessibilityValue(String(format: "%.1f%点", progress))
    }
}

#Preview {
    ProgressRing(progress: 4.7)
}
