//
//  InterviewActionRow.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct InterviewActionRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.custom(Font.appSemiBold, size: 14))
                    .foregroundStyle(Color.appGrayFont)
                Spacer()
                Image(systemName: icon)
            }
        }
        .tapScaleEffect()
        .contentShape(Rectangle())
    }
}
