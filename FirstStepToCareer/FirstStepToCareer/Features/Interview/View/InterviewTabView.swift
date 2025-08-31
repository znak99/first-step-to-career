//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI
import Shimmer

struct InterviewTabView: View {
    // MARK: - Properties
    private let grid3: Array = Array(
        repeating: GridItem(.flexible(), spacing: ACLayout.Spacing.medium),
        count: 3)
    @ObservedObject var vm: InterviewTabViewModel
    @EnvironmentObject private var nc: NavigationController

    // MARK: - Body
    var body: some View {
        ZStack {
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()

            VStack {
                // === Header
                TabViewHeader(
                    icon: ACIcon.Vector.personSquareBlack,
                    title: "Interview",
                    trailingActionIcon: ACIcon.Vector.resumeCardGray,
                    trailingActionLabel: "履歴書"
                ) {
                    vm.resumeButtonTapped {
                        nc.path.append(.resumeView)
                    }
                }

                ScrollView {
                    VStack(spacing: ACLayout.Spacing.section) {
                        // === Analytics
                        AppSection {
                            AppSectionHeader(
                                icon: ACIcon.Vector.chartQuarterBlack,
                                text: "分析",
                                isShowProgress: vm.isLoading)
                            ZStack {
                                LazyVGrid(columns: grid3, spacing: ACLayout.Spacing.medium) {
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
                            if let results = vm.interviewResults, !results.isEmpty {
                                Divider()
                                InterviewActionRow(label: "分析結果の詳細を見る") {
                                    vm.analyticsButtonTapped {
                                        nc.path.append(.analyticsView)
                                    }
                                }
                            }
                        }
                        .shimmering(active: vm.isAppearing)

                        // === History
                        AppSection {
                            AppSectionHeader(
                                icon: ACIcon.Vector.historyBlack,
                                text: "履歴",
                                isShowProgress: vm.isLoading)
                            if let result = vm.highestScoreResult {
                                InterviewHistoryRow(result: result)
                                Divider()
                                InterviewActionRow(label: "過去の面接履歴を見る") {
                                    vm.historyButtonTapped {
                                        nc.path.append(.historyListView)
                                    }
                                }
                            } else {
                                if vm.isSignedin {
                                    InterviewNoDataRow(
                                        icon: ACIcon.Image.noDataYellow3D,
                                        text: "模擬面接データが見つかりません"
                                    )
                                } else {
                                    InterviewNoDataRow(
                                        icon: ACIcon.Image.unauthenticatedYellow3D,
                                        text: "会員情報がないようです\nログインしたら模擬面接結果が保存されます！"
                                    )
                                    GradientRowButton(
                                        title: "ログインする",
                                        icon: ACIcon.Vector.entryWhite
                                    ) {
                                        vm.signinBUttonTapped {
                                            nc.path.append(.signinView)
                                        }
                                    }
                                }
                            }
                        }
                        .shimmering(active: vm.isAppearing)

                        // === Interview
                        AppSection {
                            AppSectionHeader(
                                icon: ACIcon.Vector.webCamBlack,
                                text: "面接")
                            if !vm.isAppearing {
                                Text("簡単な情報を入力して模擬面接を行いましょう！")
                                    .appCaptionStyle()
                                GradientRowButton(
                                    title: "模擬面接を始める",
                                    icon: ACIcon.Vector.focusWhite
                                ) {
                                    vm.startButtonTapped {
                                        nc.path.append(.interviewInfoFormView)
                                    }
                                }
                            }
                        }
                        .shimmering(active: vm.isAppearing)
                    }
                }
                .padding(.top, ACLayout.Padding.medium)
                .refreshable {
                    withAnimation {
                        vm.loadInterviewData()
                    }
                }
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
        .onAppear {
            withAnimation {
                vm.appAppeared()
            }
        }
    }
    
    // MARK: - Helpers
    private var analyticsMetrics: [AnalyticsPreviewMetric] {
        [
            .init("速度", vm.analyticsPreviewSpeechSpeedScore, ACColor.Analytics.speechSpeed),
            .init("沈黙", vm.analyticsPreviewSilenceScore, ACColor.Analytics.silence),
            .init("動き", vm.analyticsPreviewHeadDirectionScore, ACColor.Analytics.headDirection),
            .init("視線", vm.analyticsPreviewGazeScore, ACColor.Analytics.gaze),
            .init("表情", vm.analyticsPreviewExpressionScore, ACColor.Analytics.expression),
            .init("総合", vm.analyticsPreviewTotalScore, ACColor.Analytics.total)
        ]
    }
}

#Preview {
    InterviewTabView(vm: InterviewTabViewModel())
        .environmentObject(NavigationController())
}
