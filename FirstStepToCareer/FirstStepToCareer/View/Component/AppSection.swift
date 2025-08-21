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
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.section))
    }
}
