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
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(ACIcon.Vector.checkSquareGreen)
                .resizable()
                .scaledToFit()
                .extraSmallFrame(alignment: .center)
            Text("カメラ及びマイクを確認します！")
                .appCaptionStyle()
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
}

#Preview {
    InterviewViewPreparingHeader(transcript: "カメラ及びマイクを確認します！何でも喋ってください！ださださださださださださださださださ")
}
