//
//  TabViewHeader.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct TabViewHeader: View {
    // MARK: - Variables
    let icon: String
    let title: String
    var trailingActionIcon: String?
    var trailingActionLabel: String?
    var action: (() -> Void)?
    
    // MARK: - UI
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                HStack {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .mediumFrame(alignment: .center)
                    Text(title)
                        .font(.custom(ACFont.Weight.semiBold, size: ACFont.Size.large, relativeTo: .title))
                        .foregroundStyle(ACColor.Font.black)
                }
                Spacer()
                
                if let trailingActionIcon, let trailingActionLabel, let action {
                    Button(action: action) {
                        HStack {
                            Image(trailingActionIcon)
                                .resizable()
                                .scaledToFit()
                                .smallFrame(alignment: .center)
                            Text(trailingActionLabel)
                                .font(.custom(ACFont.Weight.medium, size: ACFont.Size.small, relativeTo: .subheadline))
                                .foregroundStyle(ACColor.Font.gray)
                        }
                        .padding(ACLayout.Padding.extraSmall)
                    }
                    .tapScaleEffect()
                }
            }
        }
    }
}

#Preview {
    TabViewHeader(
        icon: ACIcon.Vector.personSquareBlack,
        title: "Interview",
        trailingActionIcon: ACIcon.Vector.resumeCardGray,
        trailingActionLabel: "履歴書管理",
        action: {}
    )
}
