//
//  InterviewMetricRing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct MetricRing: View {
    // MARK: - Properties
    let label: String
    let score: Double
    let gradientStart: Color
    let gradientEnd: Color

    // MARK: - Body
    var body: some View {
        VStack(spacing: ACLayout.Spacing.medium) {
            Text(label)
                .font(.custom(ACFont.Weight.medium, size: ACFont.Size.extraSmall, relativeTo: .caption))
            ProgressRing(
                progress: score,
                thickness: 8,
                gradient: AngularGradient(colors: [gradientStart, gradientEnd], center: .center)
            )
            .largeFrame(alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding(ACLayout.Padding.small)
        .background(
            LinearGradient(
                colors: [gradientStart.opacity(0.1), gradientEnd.opacity(0.1)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: ACLayout.Radius.medium)
                .stroke(gradientStart.opacity(0.2), lineWidth: 1)
        }
    }
}
