//
//  InterviewViewTopBarExitButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct InterviewViewTopBarExitButton: View {
    // MARK: - Properties
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack {
            Spacer()
            Button(
                action: action,
                label: {
                    Image(ACIcon.Vector.xBlack)
                        .resizable()
                        .scaledToFit()
                        .mediumFrame(alignment: .center)
                        .padding(ACLayout.Padding.extraSmall)
                        .background {
                            ACColor.Font.white.opacity(0.7)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
                        .overlay {
                            RoundedRectangle(cornerRadius: ACLayout.Radius.medium)
                                .stroke(ACColor.Font.white, lineWidth: 1)
                        }
                }
            )
        }
    }
}

#Preview {
    InterviewViewTopBarExitButton(action: {})
}
