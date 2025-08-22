//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI
import Shimmer

struct InterviewTabView: View {
    // MARK: - Dependencies
    @StateObject var vm = InterviewTabViewModel()
    @EnvironmentObject private var nc: NavigationController

    // MARK: - UI State
    @State private var isBusy = false
    
    // MARK: - Variables
    private let grid3 = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack {
                // Header
                TabViewHeader(
                    icon: InterviewTabIcon.header,
                    title: "Interview",
                    trailingActionIcon: InterviewTabIcon.resume,
                    trailingActionLabel: "履歴書"
                ) {
                    navigate(.interviewResumeView)
                }

                ScrollView {
                    // ===== Analytics =====
                    AppSection {
                        AppSectionHeader(icon: InterviewTabIcon.Analytics.header, text: "分析")
                        if vm.state == .idle {
                            if let results = vm.interviewResults, !results.isEmpty {
                                ZStack {
                                    LazyVGrid(columns: grid3, spacing: 8) {
                                        ForEach(analyticsMetrics, id: \.label) { metric in
                                            MetricRing(
                                                label: metric.label,
                                                score: metric.score,
                                                gradientStart: metric.start,
                                                gradientEnd: metric.end
                                            )
                                        }
                                    }
                                }
                                Divider()
                                InterviewActionRow(
                                    title: "分析結果の詳細を見る",
                                    icon: SFSymbolsIcon.chevronRight
                                ) {
                                    navigate(.interviewAnalyticsView)
                                }
                            } else {
                                InterviewNoDataRow(
                                    icon: InterviewTabIcon.Analytics.noData,
                                    text: "分析データが見つかりません"
                                )
                            }
                        } else if vm.state == .fetching {
                            // TODO: - 인디케이터 바꾸기
                            ProgressView()
                        }
                    }
                    .padding(.top)
                    .shimmering(active: vm.state == .appearing)

                    // ===== History =====
                    AppSection {
                        AppSectionHeader(icon: InterviewTabIcon.History.header, text: "履歴")
                        if vm.state == .idle {
                            if let results = vm.interviewResults {
                                if results.isEmpty {
                                    InterviewNoDataRow(
                                        icon: InterviewTabIcon.History.noData,
                                        text: "模擬面接データが見つかりません"
                                    )
                                } else if let best = vm.highestScoreResult {
                                    Text("この模擬面接すごく良かったです！")
                                        .appCaptionStyle()
                                    HStack(alignment: .firstTextBaseline) {
                                        Text(best.companyName)
                                            .font(.custom(Font.appSemiBold, size: 20))
                                        Spacer()
                                        Text(best.createdAt.flatMap {
                                            AppConstant.formatDate($0.dateValue())
                                        } ?? "yyyy/MM/dd")
                                            .font(.custom(Font.appSemiBold, size: 12))
                                            .foregroundStyle(Color.appGray)
                                    }
                                    Divider()
                                    InterviewActionRow(
                                        title: "過去の面接履歴を見る",
                                        icon: SFSymbolsIcon.chevronRight
                                    ) {
                                        navigate(.interviewHistoryListView)
                                    }
                                    .disabled(isBusy)
                                    .foregroundStyle(Color.appGray)
                                }
                            } else {
                                InterviewNoDataRow(
                                    icon: InterviewTabIcon.History.unauthenticated,
                                    text: "会員情報がないようです\nログインしたら模擬面接結果が保存されます！"
                                )
                                GradientNavigationButton(
                                    title: "ログインする",
                                    icon: InterviewTabIcon.History.signin
                                ) {
                                    navigate(.signinView)
                                }
                                .padding(.top, 8)
                            }
                        } else if vm.state == .fetching {
                            // TODO: - 인디케이터 바꾸기
                            ProgressView()
                        }
                    }
                    .padding(.top)
                    .shimmering(active: vm.state == .appearing)

                    // ===== Interview =====
                    AppSection {
                        AppSectionHeader(icon: InterviewTabIcon.Interview.header, text: "面接")
                        if vm.state != .appearing {
                            Text("簡単な情報を入力して模擬面接を行いましょう！")
                                .appCaptionStyle()
                            GradientNavigationButton(
                                title: "模擬面接を始める",
                                icon: InterviewTabIcon.Interview.nav
                            ) {
                                navigate(.interviewPrepareView)
                            }
                            .padding(.top, 8)
                            .disabled(isBusy)
                        }
                    }
                    .padding(.top)
                    .shimmering(active: vm.state == .appearing)
                }
                .refreshable {
                    withAnimation {
                        vm.loadInterviewData()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            withAnimation {
                vm.state = .appearing
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    vm.state = .idle
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var analyticsMetrics: [AnalyticsPreviewMetric] {
        [
            .init("速度", vm.analyticsPreviewSpeechSpeedScore,
                  .appAnalyticsSpeechSpeedGradientStart, .appAnalyticsSpeechSpeedGradientEnd),
            .init("沈黙", vm.analyticsPreviewSilenceScore,
                  .appAnalyticsSilenceGradientStart, .appAnalyticsSilenceGradientEnd),
            .init("動き", vm.analyticsPreviewHeadDirectionScore,
                  .appAnalyticsHeadDirectionGradientStart, .appAnalyticsHeadDirectionGradientEnd),
            .init("視線", vm.analyticsPreviewGazeScore,
                  .appAnalyticsGazeGradientStart, .appAnalyticsGazeGradientEnd),
            .init("表情", vm.analyticsPreviewExpressionScore,
                  .appAnalyticsExpressionGradientStart, .appAnalyticsExpressionGradientEnd),
            .init("総合", vm.analyticsPreviewTotalScore,
                  .appAnalyticsTotalGradientStart, .appAnalyticsTotalGradientEnd)
        ]
    }

    // MARK: - Functions
    private func navigate(_ page: Route) {
        if !isBusy {
            isBusy = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                nc.pagePath.append(page)
                isBusy = false
            }
        }
    }
}

#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
