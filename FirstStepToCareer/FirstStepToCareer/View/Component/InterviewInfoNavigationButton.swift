//
//  InterviewInfoNavigationButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewInfoNavigationButton: View {
    let label: String
    let isCenterLabel: Bool
    let fontWeight: String
    let textColor: Color
    let backgroundColor: Color
    let verticalPadding: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    if isCenterLabel {
                        Spacer()
                    }
                    Text(label)
                    Spacer()
                    Image(systemName: AppConstants.chevronRight)
                }
                .font(.custom(fontWeight, size: 16, relativeTo: .subheadline))
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        )
        .padding(.trailing, 12)
        .padding(.vertical, verticalPadding)
        .background(backgroundColor)
        .foregroundStyle(textColor)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.buttonRadius))
    }
}

#Preview {
    InterviewInfoNavigationButton(
        label: "模擬面接を始める",
        isCenterLabel: true,
        fontWeight: Font.appSemiBold,
        textColor: Color.white,
        backgroundColor: Color.black,
        verticalPadding: 8,
        action: {})
}
