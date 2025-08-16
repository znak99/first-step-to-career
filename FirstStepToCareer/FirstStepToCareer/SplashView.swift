//
//  SplashView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct SplashView: View {
    
    let logoSize: CGFloat = 92
    
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
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    SplashView()
}
