//
//  SplashView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct SplashView: View {
    // MARK: - Body
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [ACColor.Brand.GradientStart, ACColor.Brand.GradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Image(ACIcon.Logo.white)
                    .resizable()
                    .scaledToFit()
                    .extraLargeFrame(alignment: .center)
                        
                Text("就活一歩")
                    .font(.custom(ACFont.Weight.semiBold, size: ACFont.Size.large, relativeTo: .title))
                    .foregroundStyle(ACColor.Font.white)
            }
        }
    }
}

#Preview {
    SplashView()
}
