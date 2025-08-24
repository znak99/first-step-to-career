//
//  AppSection.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct AppSection<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack { content }
            .padding(ACLayout.Padding.medium)
            .background(ACColor.Font.white)
            .clipShape(RoundedRectangle(cornerRadius: ACLayout.Radius.large))
    }
}
