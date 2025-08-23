//
//  RecruitTypeButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct RecruitTypeButton: View {
    // MARK: - Properties
    let type: RecruitType
    @Binding var currentType: RecruitType
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    if type == .new {
                        Image(type == currentType
                            ? ACIcon.Vector.graduationCapWhite : ACIcon.Vector.graduationCapBlack)
                        .resizable()
                        .scaledToFit()
                        .smallFrame(alignment: .center)
                    } else {
                        Image(type == currentType
                            ? ACIcon.Vector.suitcaseWhite : ACIcon.Vector.suitcaseBlack)
                        .resizable()
                        .scaledToFit()
                        .smallFrame(alignment: .center)
                    }
                    Text(type.label)
                        .font(.custom(ACFont.Weight.medium, size: ACFont.Size.small))
                }
                .frame(maxWidth: .infinity)
                .padding(ACLayout.Padding.extraSmall)
                .foregroundStyle(type == currentType ? .white : .black)
                .background {
                    LinearGradient(
                        colors: [
                            type == currentType
                            ? ACColor.Brand.GradientStart : ACColor.Brand.backgroundPrimary,
                            type == currentType
                            ? ACColor.Brand.GradientEnd : ACColor.Brand.backgroundPrimary
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
            }
        )
        .tapScaleEffect()
    }
}

#Preview {
    RecruitTypeButton(type: .new, currentType: .constant(.new), action: {})
}
