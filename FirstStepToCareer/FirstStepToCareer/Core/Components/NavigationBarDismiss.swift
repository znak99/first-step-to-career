//
//  NavigationBarDismiss.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

struct NavigationBarDismiss: View {
    // MARK: - Properties
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(
            action: action,
            label: {
                Image(ACIcon.Vector.arrowLeftBlack)
                    .resizable()
                    .scaledToFit()
                    .mediumFrame(alignment: .center)
            }
        )
    }
}

#Preview {
    NavigationBarDismiss(action: {})
}
