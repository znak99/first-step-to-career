//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewTabView: View {
    // MARK: - Variables
    @State var isNoHistory = false
    
    @EnvironmentObject var navigationController: NavigationController
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            Color.appBackground.ignoresSafeArea()
            
            // Main Contents
            VStack {
                
                // Header
                VStack {
                    HStack {
                        Image(systemName: "video.fill")
                            .font(.title2)
                            .frame(width: 24, height: 24)
                            .rotationEffect(.degrees(-10))
                        Text("Mock Interview")
                            .font(.custom(Font.appExtraBold, size: 24, relativeTo: .title2))
                        Spacer()
                    }
                    .foregroundStyle(Color.appGrayFont)
                    Text("模擬面接で本番を想定した練習をすれば\n落ち着いて話せて自分らしさをしっかり伝えられます！")
                        .font(.custom(Font.appMedium, size: 12, relativeTo: .title2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Scroll View
                ScrollView(.vertical, showsIndicators: false) {
                    // History
                    VStack {
                        if isNoHistory {
                            VStack {
                                Text("模擬面接データがないようですね\nログインすると過去の模擬面接が確認できます！")
                                    .font(.custom(Font.appMedium, size: 12, relativeTo: .subheadline))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button(action: {
                                    // TODO: - Navigation 처리
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("ログインする")
                                            .font(.custom(Font.appSemiBold, size: 16, relativeTo: .footnote))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background {
                                    LinearGradient(colors: [.appPrimaryGradient01, .appPrimaryGradient02],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                                .padding(4)
                            }
                        } else {
                            Button(action: {
                                // TODO: - Navigation 처리
                            }) {
                                VStack {
                                    Text("この模擬面接すごく良かったです！👍")
                                        .font(.custom(Font.appMedium, size: 12, relativeTo: .subheadline))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack(alignment: .firstTextBaseline) {
                                        Text("株式会社就活一歩")
                                            .font(.custom(Font.appBold, size: 20, relativeTo: .title))
                                        Spacer()
                                        Text("12/2")
                                            .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                                            .foregroundStyle(Color.appGrayFont)
                                    }
                                    HStack {
                                        VStack(alignment: .center) {
                                            Image(systemName: "building.2.fill")
                                            Image(systemName: "graduationcap.fill")
                                        }
                                        .font(.footnote)
                                        VStack(alignment: .leading) {
                                            Text("IT企業")
                                            Text("新卒")
                                        }
                                        .font(.custom(Font.appMedium, size: 14, relativeTo: .subheadline))
                                        Spacer()
                                        ZStack {
                                            CircleLineShape()
                                                .stroke(Color.appTabBarAccent.opacity(0.2),
                                                        style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            CircleLineShape(endAngleAt: 136)
                                                .stroke(Color.appTabBarAccent,
                                                        style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                            Text("\(String(format: "%.1f", 9.9))")
                                                .font(.custom(Font.appSemiBold, size: 16))
                                        }
                                        .frame(width: 40, height: 40)
                                        Text("点")
                                            .font(.custom(Font.appBold, size: 20, relativeTo: .subheadline))
                                        Spacer()
                                        Text("詳細はここ！👆")
                                            .font(.custom(Font.appRegular, size: 12, relativeTo: .footnote))
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(Color.black)
                                    }
                                }
                            }
                            .foregroundStyle(.black)
                            Divider()
                            Button(action: {}) {
                                HStack {
                                    Text("過去の模擬面接を見る")
                                        .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.subheadline)
                                        .fontWeight(.regular)
                                }
                            }
                            .foregroundStyle(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                    .padding(.top)
                    
                    // Mock Interview
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
