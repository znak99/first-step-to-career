//
//  InterviewInfoFormHeaderCaption.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct InterviewInfoFormHeaderCaption: View {
    // MARK: - Properties
    let icon: String
    let text: String
    let alignment: VerticalAlignment
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: alignment) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .extraSmallFrame(alignment: .center)
            Text(text)
                .appCaptionStyle()
        }
    }
}

#Preview {
    InterviewInfoFormHeaderCaption(
        icon: ACIcon.Image.checkSquareBlack3D,
        text: "Sample Text",
        alignment: .top)
}
