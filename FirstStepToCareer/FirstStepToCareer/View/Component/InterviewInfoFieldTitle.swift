//
//  InterviewInfoFieldTitle.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewInfoFieldTitle: View {
    // MARK: - Variables
    let title: String
    let isRequired: Bool
    
    // MARK: - UI
    var body: some View {
        HStack {
            Circle()
                .frame(width: 4, height: 4)
            Text(title)
                .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
            Text(isRequired ? "（必須）" : "（任意）")
                .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                .foregroundStyle(Color.appGrayFont)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    InterviewInfoFieldTitle(title: "会社名", isRequired: true)
}
