//
//  InterviewInfoRecruitTypeButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewInfoRecruitTypeButton: View {
    let icon: String
    let label: String
    let isNew: Bool
    var action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Image(systemName: icon)
                        .font(.subheadline)
                    Text(label)
                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                }
                .frame(maxWidth: .infinity)
            }
        )
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(isNew ? Color.appAccentColor : Color.appBackground)
        .foregroundStyle(isNew ? Color.white : Color.black)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.buttonRadius))
    }
}

#Preview {
    InterviewInfoRecruitTypeButton(
        icon: RecruitType.new.icon,
        label: RecruitType.new.label,
        isNew: true,
        action: {})
}
