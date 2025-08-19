//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI
import Charts

// Temp Data
struct InterviewData: Identifiable {
    let id: UUID = .init()
    let day: String
    let count: Int
}

struct InterviewTabView: View {
    // MARK: - Variables
    let buttonDelay: DispatchTime = .now() + 0.1
    @State private var isSomeButtonTapped = false
    @StateObject var interviewVM = InterviewViewModel()
    @EnvironmentObject private var nc: NavigationController
    @FocusState private var focus: FocusTarget?
    
    let data: [InterviewData] = [
        InterviewData(day: "1", count: 2),
        InterviewData(day: "2", count: 1),
        InterviewData(day: "3", count: 3),
        InterviewData(day: "4", count: 0),
        InterviewData(day: "5", count: 0),
        InterviewData(day: "6", count: 1),
        InterviewData(day: "7", count: 0),
        InterviewData(day: "8", count: 1),
        InterviewData(day: "9", count: 0),
        InterviewData(day: "10", count: 0),
        InterviewData(day: "11", count: 0),
        InterviewData(day: "12", count: 3),
        InterviewData(day: "13", count: 0),
        InterviewData(day: "14", count: 0),
        InterviewData(day: "15", count: 2),
        InterviewData(day: "16", count: 0),
        InterviewData(day: "17", count: 1),
        InterviewData(day: "18", count: 0),
        InterviewData(day: "19", count: 4),
        InterviewData(day: "20", count: 0),
        InterviewData(day: "21", count: 3),
        InterviewData(day: "21", count: 0),
        InterviewData(day: "22", count: 1),
        InterviewData(day: "23", count: 0),
        InterviewData(day: "24", count: 1),
        InterviewData(day: "25", count: 0),
        InterviewData(day: "26", count: 1),
        InterviewData(day: "27", count: 0),
        InterviewData(day: "28", count: 0),
        InterviewData(day: "29", count: 1),
        InterviewData(day: "30", count: 1),
        InterviewData(day: "31", count: 2)
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
                    icon: AppConstants.interviewTabHeaderIcon,
                    title: "Interview",
                    caption: "模擬面接で本番を想定した練習をすれば\n落ち着いて話せて自分らしさをしっかり伝えられます！"
                )
                
                ScrollView {
                    // Analysis
                    // TODO: - 분석할 데이터 없을때 보여줄 뷰 작성하기
                    VStack(spacing: 2) {
                        categoryTitle(icon: AppConstants.interviewTabAnalysisIcon, text: "分析")
                        VStack { // TODO: - 차트 디자인 및 내용 수정하기
                            Chart(data) { item in
                                BarMark(
                                    x: .value("", item.day),
                                    y: .value("", item.count))
                            }
                            .frame(maxHeight: 120)
                            .foregroundStyle(Color.appGrayFont)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
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
                                        Image(systemName: AppConstants.chevronRight)
                                    }
                                }
                            )
                            .disabled(isSomeButtonTapped)
                            .tapScaleEffect()
                            .foregroundStyle(Color.appGrayFont)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.sectionRadius))
                    }
                    .padding(.top)
                    
                    Divider()
                    
                    // History
                    // TODO: - 로그인 안되어있을때 보여줄 뷰 작성하기
                    VStack(spacing: 2) {
                        categoryTitle(icon: AppConstants.interviewTabHistoryIcon, text: "履歴")
                        VStack {
                            Text("この模擬面接すごく良かったです！👍")
                                .appCaptionStyle()
                            HStack(alignment: .firstTextBaseline) {
                                Text("株式会社就活一歩")
                                    .font(.custom(Font.appSemiBold, size: 20))
                                Spacer()
                                Text("2025/08/01")
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
                                        Image(systemName: AppConstants.chevronRight)
                                    }
                                }
                            )
                            .disabled(isSomeButtonTapped)
                            .tapScaleEffect()
                            .foregroundStyle(Color.appGrayFont)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.sectionRadius))
                    }
                    .padding(.top)
                    
                    Divider()
                    
                    // Interview
                    VStack(spacing: 2) {
                        categoryTitle(icon: AppConstants.interviewTabInterviewIcon, text: "面接")
                        VStack {
                            Text("簡単な情報を入力して模擬面接を行いましょう！")
                                .appCaptionStyle()
                            Button(
                                action: {
                                    isSomeButtonTapped = true
                                    DispatchQueue.main.asyncAfter(deadline: buttonDelay) {
//                                        nc.pagePath.append(.interviewPrepareView)
                                        interviewVM.forTestMakeDummyData() // TODO: - For Test
                                        isSomeButtonTapped = false
                                    }
                                },
                                label: {
                                    HStack {
                                        Image(AppConstants.interviewTabFocus)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                        Text("模擬面接を始める")
                                            .font(.custom(Font.appSemiBold, size: 16))
                                        Spacer()
                                        Image(systemName: AppConstants.chevronRight)
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
                            .clipShape(RoundedRectangle(cornerRadius: AppConstants.boxRadius))
                            .foregroundStyle(.white)
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.sectionRadius))
                    }
                    .padding(.top)
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
                .font(.custom(Font.appMedium, size: 18))
                .foregroundStyle(Color.appGrayFont)
            Spacer()
        }
    }
}

#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
