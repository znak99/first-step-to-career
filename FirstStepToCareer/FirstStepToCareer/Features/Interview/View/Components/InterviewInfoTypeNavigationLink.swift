//
//  InterviewInfoTypeNavigationLink.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct InterviewInfoTypeNavigationLink<Destination: View>: View {
    // MARK: - Properties
    let label: String
    @ViewBuilder var destination: () -> Destination
    
    // MARK: - Body
    var body: some View {
        NavigationLink(destination: destination()) {
            HStack {
                Text(label)
                    .font(.custom(ACFont.Weight.medium,
                                  size: ACFont.Size.small,
                                  relativeTo: .footnote))
                Spacer()
                Image(ACIcon.Vector.angleRightBlack)
                    .resizable()
                    .scaledToFit()
                    .smallFrame(alignment: .center)
            }
            .padding(ACLayout.Padding.small)
            .foregroundStyle(ACColor.Font.black)
            .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.medium))
        }
        .tapScaleEffect()
    }
}

#Preview {
    InterviewInfoTypeNavigationLink(label: "fd", destination: { EmptyView() })
}
