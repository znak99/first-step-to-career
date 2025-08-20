//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewTabView: View {
    // MARK: - Variables
    let buttonDelay: DispatchTime = .now() + 0.1
    @State private var isSomeButtonTapped = false
    @StateObject var interviewVM = InterviewViewModel()
    @EnvironmentObject private var nc: NavigationController
    @FocusState private var focus: FocusTarget?
    
    let analysisGridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let analysisLabel: [String] = [
        "ペース", "沈黙", "動き",
        "視線", "表情", "総合"
    ]
    
    let analysisColor: [Color] = [
        .appAnalysisRed, .appAnalysisGreen, .appAnalysisOrange,
        .appAnalysisBlue, .appAnalysisPurple, .appAnalysisBlack
    ]
    let analysisColor1: [Color] = [
        .appAnalysisRed1, .appAnalysisGreen1, .appAnalysisOrange1,
        .appAnalysisBlue1, .appAnalysisPurple1, .appAnalysisBlack1
    ]
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            Color.appBackground.ignoresSafeArea()
            
            // Main Contents
            VStack {
                // Header
                TabViewHeader(
                    icon: AppConstant.Icon.InterviewTab.header,
                    title: "Interview",
                    trailingActionIcon: AppConstant.Icon.InterviewTab.resume,
                    trailingActionLabel: "履歴書管理"
                ) {
                    print("Interview")
                }
                
                ScrollView {
                    // Analysis
                    VStack(spacing: 16) { // TODO: - 차트 디자인 및 내용 수정하기
                        categoryTitle(icon: AppConstant.interviewTabAnalysisIcon, text: "分析")
                        if interviewVM.interviewResults != nil && !(interviewVM.interviewResults?.isEmpty ?? false) {
                            LazyVGrid(columns: analysisGridColumns, spacing: 16) {
                                ForEach(0..<6) { index in
                                    VStack {
                                        Text(analysisLabel[index])
                                            .font(.custom(Font.appMedium, size: 12))
                                        ProgressRing(
                                            progress: interviewVM.analysisResultAvgs[index],
                                            thickness: 8,
                                            gradient: AngularGradient(
                                                colors: [
                                                    analysisColor[index],
                                                    analysisColor1[index],
                                                    analysisColor[index]
                                                ],
                                                center: .center)
                                        )
                                        .frame(
                                            minWidth: 40, idealWidth: 48, maxWidth: 56,
                                            minHeight: 40, idealHeight: 48, maxHeight: 56,
                                            alignment: .center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background {
                                        LinearGradient(
                                            colors: [
                                                analysisColor[index].opacity(0.1),
                                                analysisColor1[index].opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.boxRadius))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: AppConstant.boxRadius)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(analysisColor[index].opacity(0.1))
                                    }
                                }
                            }
                            Divider()
                            Button(
                                action: {
                                    isSomeButtonTapped = true
                                    DispatchQueue.main.asyncAfter(deadline: buttonDelay) {
                                        nc.pagePath.append(.interviewAnalysisView)
                                        isSomeButtonTapped = false
                                    }
                                },
                                label: {
                                    HStack {
                                        Text("分析結果の詳細を見る")
                                            .font(.custom(Font.appSemiBold, size: 14))
                                        Spacer()
                                        Image(systemName: AppConstant.chevronRight)
                                    }
                                }
                            )
                            .disabled(isSomeButtonTapped)
                            .tapScaleEffect()
                            .foregroundStyle(Color.appGrayFont)
                        } else {
                            HStack {
                                Image(AppConstant.interviewTabNoData)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        minWidth: 28, idealWidth: 32, maxWidth: 36,
                                        minHeight: 28, idealHeight: 32, maxHeight: 36, alignment: .center)
                                Text("分析できそうなデータが見つかりません")
                                    .appCaptionStyle()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.sectionRadius))
                    .padding(.top)
                    
                    // History
                    VStack {
                        categoryTitle(icon: AppConstant.interviewTabHistoryIcon, text: "履歴")
                        if let results = interviewVM.interviewResults,
                           let highestResult = interviewVM.highestScoreResult {
                            if results.isEmpty {
                                // TODO: - 과거 모의면접 데이터 없을때 보여줄 뷰 작성하기
                            } else {
                                Text("この模擬面接すごく良かったです！")
                                    .appCaptionStyle()
                                HStack(alignment: .firstTextBaseline) {
                                    Text(highestResult.companyName)
                                        .font(.custom(Font.appSemiBold, size: 20))
                                    Spacer()
                                    Text(AppConstant.formatDate((highestResult.createdAt?.dateValue())!))
                                        .font(.custom(Font.appSemiBold, size: 12))
                                        .foregroundStyle(Color.appGrayFont)
                                }
                                Divider()
                                Button(
                                    action: {
                                        isSomeButtonTapped = true
                                        DispatchQueue.main.asyncAfter(deadline: buttonDelay) {
                                            nc.pagePath.append(.interviewHistoryListView)
                                            isSomeButtonTapped = false
                                        }
                                    },
                                    label: {
                                        HStack {
                                            Text("過去の面接履歴を見る")
                                                .font(.custom(Font.appSemiBold, size: 14))
                                            Spacer()
                                            Image(systemName: AppConstant.chevronRight)
                                        }
                                    }
                                )
                                .disabled(isSomeButtonTapped)
                                .tapScaleEffect()
                                .foregroundStyle(Color.appGrayFont)
                            }
                        } else {
                            HStack {
                                Image(AppConstant.interviewTabUnauthorized)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        minWidth: 28, idealWidth: 32, maxWidth: 36,
                                        minHeight: 28, idealHeight: 32, maxHeight: 36, alignment: .center)
                                Text("会員情報がないようです\nログインしたら模擬面接結果が保存されます！")
                                    .appCaptionStyle()
                                Spacer()
                            }
                            Button(
                                action: {
                                    isSomeButtonTapped = true
                                    DispatchQueue.main.asyncAfter(deadline: buttonDelay) {
                                        interviewVM.forTestMakeDummyData()
                                        isSomeButtonTapped = false
                                    }
                                },
                                label: {
                                    HStack {
                                        Image(AppConstant.interviewTabSignIn)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("ログインする")
                                            .font(.custom(Font.appSemiBold, size: 16))
                                        Spacer()
                                        Image(systemName: AppConstant.chevronRight)
                                    }
                                }
                            )
                            .disabled(isSomeButtonTapped)
                            .tapScaleEffect()
                            .padding(12)
                            .background {
                                LinearGradient(
                                    colors: [Color.appPrimaryGradient01, Color.appPrimaryGradient02],
                                    startPoint: .top, endPoint: .bottom)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: AppConstant.boxRadius))
                            .foregroundStyle(.white)
                            .padding(.top, 8)
                        }
                    }
                    .onTapGesture {
                        interviewVM.forTestMakeDummyData() // TODO: - 삭제하기
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.sectionRadius))
                    .padding(.top)
                    
                    Divider()
                    
                    // Interview
                    VStack {
                        categoryTitle(icon: AppConstant.interviewTabWebCamIcon, text: "面接")
                        Text("簡単な情報を入力して模擬面接を行いましょう！")
                            .appCaptionStyle()
                        Button(
                            action: {
                                isSomeButtonTapped = true
                                DispatchQueue.main.asyncAfter(deadline: buttonDelay) {
                                    nc.pagePath.append(.interviewPrepareView)
                                    isSomeButtonTapped = false
                                }
                            },
                            label: {
                                HStack {
                                    Image(AppConstant.interviewTabFocus)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("模擬面接を始める")
                                        .font(.custom(Font.appSemiBold, size: 16))
                                    Spacer()
                                    Image(systemName: AppConstant.chevronRight)
                                }
                            }
                        )
                        .disabled(isSomeButtonTapped)
                        .tapScaleEffect()
                        .padding(12)
                        .background(Color.appAnalysisBlack)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstant.boxRadius))
                        .foregroundStyle(.white)
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.sectionRadius))
                    .padding(.top)
                    
                }
                .refreshable {
                    interviewVM.forTestMakeDummyData()
                }
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: AppPage.self) { page in
                switch page {
                case .interviewAnalysisView:
                    InterviewAnalysisView()
                case .interviewHistoryListView:
                    InterviewHistoryListView()
                case .interviewPrepareView:
                    InterviewPrepareView()
                default:
                    EmptyView()
                }
            }
        }
        
    }
}

// MARK: - Sub Views
private extension InterviewTabView {
    @ViewBuilder
    private func categoryTitle(icon: String, text: String) -> some View {
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

#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
