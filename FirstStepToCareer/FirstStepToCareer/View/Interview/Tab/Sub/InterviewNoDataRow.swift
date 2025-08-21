//
//  InterviewNoDataRow.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct InterviewNoDataRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 28, idealWidth: 32, maxWidth: 36,
                       minHeight: 28, idealHeight: 32, maxHeight: 36)
            Text(text)
                .appCaptionStyle()
            Spacer()
        }
    }
}
