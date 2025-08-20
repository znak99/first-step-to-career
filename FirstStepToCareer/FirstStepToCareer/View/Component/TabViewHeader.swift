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
    let trailingActionIcon: String?
    let trailingActionLabel: String?
    let action: (() -> Void)?
    
    // MARK: - UI
    var body: some View {
        VStack {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        minWidth: 24, idealWidth: 28, maxWidth: 32,
                        minHeight: 24, idealHeight: 28, maxHeight: 32
                    )
                Text(title)
                    .font(.custom(Font.appSemiBold, size: 20, relativeTo: .title2))
                    .foregroundStyle(Color.black)
                Spacer()
                
                if let trailingActionIcon, let trailingActionLabel, let action {
                    Button(action: action) {
                        HStack {
                            Image(trailingActionIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    minWidth: 20, idealWidth: 24, maxWidth: 28,
                                    minHeight: 20, idealHeight: 24, maxHeight: 28
                                )
                            Text(trailingActionLabel)
                                .font(.custom(Font.appMedium, size: 16, relativeTo: .subheadline))
                                .foregroundStyle(Color.appGrayFont)
                        }
                        .padding(4)
                    }
                    .tapScaleEffect()
                }
            }
        }
    }
}

#Preview {
    TabViewHeader(
        icon: AppConstant.Icon.InterviewTab.header,
        title: "Interview",
        trailingActionIcon: AppConstant.Icon.InterviewTab.resume,
        trailingActionLabel: "履歴書管理",
        action: {}
    )
}
