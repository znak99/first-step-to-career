//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewTabView: View {
    // MARK: - Variables
    @StateObject var viewmodel = InterviewViewModel()
    @EnvironmentObject var navigationController: NavigationController
    @FocusState private var focus: FocusTarget?
    
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
                        if let _ = viewmodel.bestHistory {
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
                                        Image(systemName: AppConstants.chevronRight)
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
                    
                    Divider()
                    
                    // Mock Interview Info
                    Text("簡単な情報を入力して模擬面接を行いましょう！")
                        .font(.custom(Font.appMedium, size: 12, relativeTo: .title2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        VStack {
                            // Company Name
                            VStack(spacing: 2) {
                                HStack {
                                    Circle()
                                        .frame(width: 4, height: 4)
                                    Text("会社名")
                                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                                    Text("（必須）")
                                        .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                                        .foregroundStyle(Color.appGrayFont)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                ZStack(alignment: .leading) {
                                    if viewmodel.mockInterviewInfo.companyName.isEmpty {
                                        Text("株式会社就活一歩")
                                            .foregroundColor(.gray)
                                            .offset(y: 0)
                                    }
                                    TextField("", text: $viewmodel.mockInterviewInfo.companyName)
                                        .autocorrectionDisabled(true)
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                        .focused($focus, equals: .companyName)
                                }
                                .font(.custom(Font.appRegular, size: 16, relativeTo: .subheadline))
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: AppConstants.boxRadius)
                                        .fill(Color.appBackground)
                                )
                                .padding(.vertical, 4)
                            }
                            
                            // Recruit Type
                            VStack(spacing: 2) {
                                HStack {
                                    Circle()
                                        .frame(width: 4, height: 4)
                                    Text("活動区分")
                                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                                    Text("（必須）")
                                        .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                                        .foregroundStyle(Color.appGrayFont)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                HStack(spacing: 24) {
                                    Button(action: {
                                        viewmodel.mockInterviewInfo.recruitType = .new
                                    }) {
                                        HStack {
                                            Image(systemName: RecruitType.new.icon)
                                                .font(.subheadline)
                                            Text(RecruitType.new.label)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .padding(8)
                                    .background(viewmodel.mockInterviewInfo.recruitType == .new ? Color.appPrimaryGradient01 : Color.appBackground)
                                    .foregroundStyle(viewmodel.mockInterviewInfo.recruitType == .new ? Color.white : Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                                    Button(action: {
                                        viewmodel.mockInterviewInfo.recruitType = .old
                                    }) {
                                        HStack {
                                            Image(systemName: RecruitType.old.icon)
                                                .font(.subheadline)
                                            Text(RecruitType.old.label)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .padding(8)
                                    .background(viewmodel.mockInterviewInfo.recruitType == .old ? Color.appPrimaryGradient01 : Color.appBackground)
                                    .foregroundStyle(viewmodel.mockInterviewInfo.recruitType == .old ? Color.white : Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                                }
                                .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                                .padding(.vertical, 4)
                            }
                            
                            // Company Type
                            VStack(spacing: 2) {
                                HStack {
                                    Circle()
                                        .frame(width: 4, height: 4)
                                    Text("企業分野")
                                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                                    Text("（必須）")
                                        .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                                        .foregroundStyle(Color.appGrayFont)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Button(action: {
                                    // Navigation처리
                                }) {
                                    HStack {
                                        Text(viewmodel.mockInterviewInfo.companyType.rawValue)
                                        Spacer()
                                        Image(systemName: AppConstants.chevronRight)
                                            .font(.subheadline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                }
                                .padding([.vertical, .trailing], 8)
                                .background(Color.white)
                                .foregroundStyle(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                                .font(.custom(Font.appRegular, size: 16, relativeTo: .subheadline))
                            }
                            
                            // CareerType
                            VStack(spacing: 2) {
                                HStack {
                                    Circle()
                                        .frame(width: 4, height: 4)
                                    Text("希望職種")
                                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                                    Text("（必須）")
                                        .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                                        .foregroundStyle(Color.appGrayFont)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Button(action: {
                                    // Navigation처리
                                }) {
                                    HStack {
                                        Text(viewmodel.mockInterviewInfo.companyType.rawValue)
                                        Spacer()
                                        Image(systemName: AppConstants.chevronRight)
                                            .font(.subheadline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                }
                                .padding([.vertical, .trailing], 8)
                                .background(Color.white)
                                .foregroundStyle(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                                .font(.custom(Font.appRegular, size: 16, relativeTo: .subheadline))
                            }
                            Divider()
                            Button(action:{}) {
                                HStack {
                                    Spacer()
                                    Text("模擬面接を始める")
                                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .title2))
                                    Spacer()
                                    Image(systemName: AppConstants.chevronRight)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(.white)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.appTabBarAccent)
                            .clipShape(RoundedRectangle(cornerRadius: AppConstants.componentRadius))
                        }
                        .padding(.top, 2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                }
                .scrollDismissesKeyboard(.interactively)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .allowsHitTesting(focus != nil)
                .onTapGesture {
                    focus = nil
                }
        }
    }
}

#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
