//
//  InterviewHistoryRow.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct InterviewHistoryRow: View {
    // MARK: - Properties
    let result: InterviewResult
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("この模擬面接すごく良かったです！")
                .appCaptionStyle()
            HStack(alignment: .firstTextBaseline) {
                Text(result.companyName)
                    .font(.custom(ACFont.Weight.semiBold,
                                  size: ACFont.Size.medium,
                                  relativeTo: .title3))
                Spacer()
                Text(result.createdAt.flatMap {
                    String.formatDate($0.dateValue())
                } ?? "yyyy/MM/dd")
                .font(.custom(ACFont.Weight.semiBold,
                              size: ACFont.Size.extraSmall,
                              relativeTo: .caption2))
                    .foregroundStyle(ACColor.Font.gray)
            }
        }
    }
}
