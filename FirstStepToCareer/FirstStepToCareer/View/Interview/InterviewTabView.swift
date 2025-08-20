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
    
    let graphPreviewColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
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
                    icon: InterviewTabIcon.header,
                    title: "Interview",
                    trailingActionIcon: InterviewTabIcon.resume,
                    trailingActionLabel: "履歴書"
                ) {
                    print("Interview")
                }
                
                // Scroll View
                ScrollView {
                    // Analytics
                    VStack {
                        categoryTitle(icon: InterviewTabIcon.Analytics.header, text: "分析")
                        if interviewVM.graphData.count > 0 {
                            LazyVGrid(columns: graphPreviewColumns, spacing: 8) {
                                ForEach(interviewVM.graphData) { graph in
                                    analyticsGraph(graph: graph)
                                }
                            }
                            Divider()
                            Button(
                                action: {
                                    isSomeButtonTapped = true
                                    DispatchQueue.main.asyncAfter(deadline: buttonDelay) {
                                        nc.pagePath.append(.interviewAnalyticsView)
                                        isSomeButtonTapped = false
                                    }
                                },
                                label: {
                                    HStack {
                                        Text("分析結果の詳細を見る")
                                            .font(.custom(Font.appSemiBold, size: 14))
                                        Spacer()
                                        Image(systemName: SFSymbolsIcon.chevronRight)
                                    }
                                }
                            )
                            .disabled(isSomeButtonTapped)
                            .tapScaleEffect()
                            .foregroundStyle(Color.appGrayFont)
                        } else {
                            HStack {
                                Image(InterviewTabIcon.Analytics.noData)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        minWidth: 28, idealWidth: 32, maxWidth: 36,
                                        minHeight: 28, idealHeight: 32, maxHeight: 36, alignment: .center)
                                Text("分析できるデータが見つかりません")
                                    .appCaptionStyle()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.section))
                    .padding(.top)
                    
                    // History
                    VStack {
                        categoryTitle(icon: InterviewTabIcon.History.header, text: "履歴")
                        if let results = interviewVM.interviewResults,
                           let highestResult = interviewVM.highestScoreResult {
                            if results.isEmpty {
                                HStack {
                                    Image(InterviewTabIcon.Analytics.noData)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            minWidth: 28, idealWidth: 32, maxWidth: 36,
                                            minHeight: 28, idealHeight: 32, maxHeight: 36, alignment: .center)
                                    Text("分析できるデータが見つかりません")
                                        .appCaptionStyle()
                                    Spacer()
                                }
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
                                            Image(systemName: SFSymbolsIcon.chevronRight)
                                        }
                                    }
                                )
                                .disabled(isSomeButtonTapped)
                                .tapScaleEffect()
                                .foregroundStyle(Color.appGrayFont)
                            }
                        } else {
                            HStack {
                                Image(InterviewTabIcon.History.unauthenticated)
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
                                        Image(InterviewTabIcon.History.signin)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("ログインする")
                                            .font(.custom(Font.appSemiBold, size: 16))
                                        Spacer()
                                        Image(systemName: SFSymbolsIcon.chevronRight)
                                    }
                                }
                            )
                            .disabled(isSomeButtonTapped)
                            .tapScaleEffect()
                            .padding(12)
                            .background {
                                LinearGradient(colors: [Color.appMainGradientStart, Color.appMainGradientEnd],
                                               startPoint: .leading, endPoint: .trailing)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
                            .foregroundStyle(.white)
                            .padding(.top, 8)
                        }
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.section))
                    .padding(.top)
                    
                    Divider()
                    
                    // Interview
                    VStack {
                        categoryTitle(icon: InterviewTabIcon.Interview.header, text: "面接")
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
                                    Image(InterviewTabIcon.Interview.focus)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("模擬面接を始める")
                                        .font(.custom(Font.appSemiBold, size: 16))
                                    Spacer()
                                    Image(systemName: SFSymbolsIcon.chevronRight)
                                }
                            }
                        )
                        .disabled(isSomeButtonTapped)
                        .tapScaleEffect()
                        .padding(12)
                        .background{
                            LinearGradient(colors: [Color.appMainGradientStart, Color.appMainGradientEnd],
                                           startPoint: .leading, endPoint: .trailing)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
                        .foregroundStyle(.white)
                        .padding(.top, 8)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.section))
                    .padding(.top)
                    
                }
                .refreshable {
                    interviewVM.forTestMakeDummyData()
                }
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: AppPage.self) { page in
                switch page {
                case .interviewAnalyticsView:
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
    private func categoryTitle(icon: String, text: String) -> some View { // 함수명 수정
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

private extension InterviewTabView {
    @ViewBuilder
    private func analyticsGraph(graph: AnalyticsPreviewGraph) -> some View {
        VStack {
            Text(graph.label)
                .font(.custom(Font.appMedium, size: 12))
            ProgressRing(
                progress: graph.score,
                thickness: 8,
                gradient: AngularGradient(
                    colors: [
                        graph.gradientStart,
                        graph.gradientEnd
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
                    graph.gradientStart.opacity(0.1),
                    graph.gradientEnd.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
        .overlay {
            RoundedRectangle(cornerRadius: AppConstant.Radius.box)
                .stroke(lineWidth: 1)
                .foregroundStyle(graph.gradientStart.opacity(0.2))
        }
    }
}

#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
