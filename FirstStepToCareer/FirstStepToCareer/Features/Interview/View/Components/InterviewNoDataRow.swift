//
//  InterviewNoDataRow.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct InterviewNoDataRow: View {
    // MARK: - Properties
    let icon: String
    let text: String
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .mediumFrame(alignment: .center)
            Text(text)
                .appCaptionStyle()
            Spacer()
        }
    }
}
