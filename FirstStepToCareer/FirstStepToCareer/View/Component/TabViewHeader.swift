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
    let iconRotateDegrees: CGFloat
    let title: String
    let caption: String
    
    // MARK: - UI
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(iconRotateDegrees))
                Text(title)
                    .font(.custom(Font.appExtraBold, size: 24, relativeTo: .title2))
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
        icon: "video.fill",
        iconRotateDegrees: -10,
        title: "Mock Interview",
        caption: "模擬面接で本番を想定した練習をすれば\n落ち着いて話せて自分らしさをしっかり伝えられます！"
    )
}
