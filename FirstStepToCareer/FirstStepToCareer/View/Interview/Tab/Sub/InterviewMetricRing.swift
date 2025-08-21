//
//  InterviewMetricRing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct MetricRing: View {
    let label: String
    let score: Double
    let gradientStart: Color
    let gradientEnd: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.custom(Font.appMedium, size: 12))
            ProgressRing(
                progress: score,
                thickness: 8,
                gradient: AngularGradient(colors: [gradientStart, gradientEnd], center: .center)
            )
            .frame(minWidth: 40, idealWidth: 48, maxWidth: 56,
                   minHeight: 40, idealHeight: 48, maxHeight: 56)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            LinearGradient(
                colors: [gradientStart.opacity(0.1), gradientEnd.opacity(0.1)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
        .overlay {
            RoundedRectangle(cornerRadius: AppConstant.Radius.box)
                .stroke(gradientStart.opacity(0.2), lineWidth: 1)
        }
    }
}
