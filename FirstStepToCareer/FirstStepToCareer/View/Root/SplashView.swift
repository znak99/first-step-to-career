//
//  SplashView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct SplashView: View {
    // MARK: - Variables
    let logoSize: CGFloat = 92
    
    // MARK: - UI
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.appPrimaryGradient01, .appPrimaryGradient02],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .frame(width: logoSize, height: logoSize)
                Text("就活一歩")
                    .font(.custom(Font.appSemiBold, size: 24, relativeTo: .title))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    SplashView()
}
