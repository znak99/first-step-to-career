//
//  InterviewActionRow.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct InterviewActionRow: View {
    // MARK: - Properties
    let label: String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.custom(ACFont.Weight.regular,
                                  size: ACFont.Size.small,
                                  relativeTo: .footnote))
                    .foregroundStyle(ACColor.Font.gray)
                Spacer()
                Image(ACIcon.Vector.angleRightGray)
                    .resizable()
                    .scaledToFit()
                    .smallFrame(alignment: .center)
            }
        }
        .tapScaleEffect()
        .contentShape(Rectangle())
    }
}

#Preview {
    InterviewActionRow(label: "Sample Text", action: {})
        .padding()
}
