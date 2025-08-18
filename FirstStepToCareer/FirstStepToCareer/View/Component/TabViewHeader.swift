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
    let caption: String
    
    // MARK: - UI
    var body: some View {
        VStack {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        minWidth: 75, idealWidth: 80, maxWidth: 85,
                        minHeight: 75, idealHeight: 80, maxHeight: 85,
                        alignment: .center)
                ViewThatFits(in: .horizontal) {
                    Text(title)
                        .font(.custom(Font.appBlack, size: 32, relativeTo: .title2))
                    Text(title)
                        .font(.custom(Font.appBlack, size: 28, relativeTo: .title2))
                }
                Spacer()
            }
            .foregroundStyle(Color.appGrayFont)
            Text(caption)
                .appCaptionStyle()
        }
    }
}

#Preview {
    TabViewHeader(
        icon: AppConstants.interviewTabHeaderIcon,
        title: "Mock Interview",
        caption: "模擬面接で本番を想定した練習をすれば\n落ち着いて話せて自分らしさをしっかり伝えられます！"
    )
}
