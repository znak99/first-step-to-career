//
//  AppSectionHeader.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct AppSectionHeader: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 4) {
            Image(icon)
                .resizable()
                .frame(width: 24, height: 24)
            Text(text)
                .font(.custom(Font.appRegular, size: 16))
                .foregroundStyle(Color.black)
            Spacer()
        }
    }
}
