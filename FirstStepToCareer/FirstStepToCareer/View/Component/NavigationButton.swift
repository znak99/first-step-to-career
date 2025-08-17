//
//  NavigationButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct NavigationButton: View {
    // MARK: - Variables
    let label: String
    let isLabelCenter: Bool
    let fontWeight: String
    let textColor: Color
    let backgroundColor: Color
    let verticalPadding: CGFloat
    let action: () -> Void
    
    // MARK: - UI
    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    if isLabelCenter {
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
    NavigationButton(
        label: "LABEL",
        isLabelCenter: true,
        fontWeight: Font.appSemiBold,
        textColor: .appBackground,
        backgroundColor: .blue, verticalPadding: 8, action: {})
}
