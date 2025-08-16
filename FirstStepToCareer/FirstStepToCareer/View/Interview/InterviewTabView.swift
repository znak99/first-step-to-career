//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewTabView: View {
    // MARK: - Variables
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            Color.appBackground.ignoresSafeArea()
            
            // Main Contents
            VStack {
                Text("Mock Interview")
                    .font(.custom(Font.appThin, size: 24, relativeTo: .subheadline))
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    InterviewTabView()
}
