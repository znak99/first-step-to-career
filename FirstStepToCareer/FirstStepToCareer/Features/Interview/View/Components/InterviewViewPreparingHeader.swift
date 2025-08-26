//
//  InterviewViewPreparingHeader.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/25.
//

import SwiftUI

struct InterviewViewPreparingHeader: View {
    // MARK: - Properties
    let transcript: String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: ACLayout.Spacing.small) {
            HStack {
                Image(ACIcon.Vector.checkSquareGreen)
                    .resizable()
                    .scaledToFit()
                    .extraSmallFrame(alignment: .center)
                Text("カメラ及びマイクを確認します！")
                    .appCaptionStyle()
                Button(
                    action: action,
                    label: {
                        Image(ACIcon.Vector.megaPhoneWhite)
                            .resizable()
                            .scaledToFit()
                            .extraSmallFrame(alignment: .center)
                    }
                )
                .padding(ACLayout.Padding.extraSmall)
                .background {
                    LinearGradient(
                        colors: [
                            ACColor.Brand.GradientStart,
                            ACColor.Brand.GradientEnd
                        ],
                        startPoint: .leading,
                        endPoint: .trailing)
                }
                .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.extraSmall))
            }
            HStack(alignment: .center) {
                Image(ACIcon.Vector.speechBlack)
                    .resizable()
                    .scaledToFit()
                    .smallFrame(alignment: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                Text(transcript.isEmpty ? "何でも喋ってください！" : transcript.lastCharacters(40))
                    .font(.custom(ACFont.Weight.regular, size: ACFont.Size.small))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
            }
        }
        .padding(ACLayout.Padding.medium)
        .background {
            ACColor.Font.white.opacity(0.7)
        }
        .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: ACLayout.Radius.medium)
                .stroke(ACColor.Font.white, lineWidth: 1)
        }
    }
}

#Preview {
    InterviewViewPreparingHeader(
        transcript: "カメラ及びマイクを確認します！何でも喋ってください！ださださださださださださださださださ",
        action: {})
}
