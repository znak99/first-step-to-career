//
//  InterviewInfoFormView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

import SwiftUI
import AlertToast

struct InterviewInfoFormView: View {
    // MARK: - Properties
    @StateObject private var vm: InterviewInfoFormViewModel = .init()
    @FocusState private var focus: FocusTarget?
    @EnvironmentObject private var nc: NavigationController
    @EnvironmentObject private var interviewOrchestrator: InterviewOrchestrator
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    // === Header Caption
                    VStack {
                        InterviewInfoFormHeaderCaption(
                            icon: ACIcon.Image.checkSquareBlack3D,
                            text: "模擬面接用の企業情報なので\n実在の会社じゃなくてもOKです！",
                            alignment: .top)
                        InterviewInfoFormHeaderCaption(
                            icon: ACIcon.Image.warningTriangleYellow3D,
                            text: "ただ、企業名以外の項目は模擬面接の質問に影響します！",
                            alignment: .center)
                    }
                    .padding(.vertical, ACLayout.Padding.small)
                    
                    AppSection {
                        VStack(spacing: ACLayout.Spacing.large) {
                            // === Company Name
                            VStack(spacing: ACLayout.Spacing.medium) {
                                AppSectionHeader(
                                    icon: ACIcon.Vector.penEditBlack,
                                    text: "企業名",
                                    lottie: vm.sectionHeaderLottie)
                                AppTextField(
                                    placeholder: "株式会社就活一歩",
                                    text: $vm.interviewInfo.companyName,
                                    focus: $focus,
                                    focusTarget: .companyName)
                            }
                            
                            // === Recruit Type
                            VStack(spacing: ACLayout.Spacing.medium) {
                                AppSectionHeader(
                                    icon: vm.interviewInfo.recruitType == .new
                                    ? ACIcon.Vector.toggleLeftBlack
                                    : ACIcon.Vector.toggleRightBlack,
                                    text: "選考区分",
                                    lottie: vm.sectionHeaderLottie)
                                HStack {
                                    RecruitTypeButton(type: .new, currentType: $vm.interviewInfo.recruitType) {
                                        vm.recruitTypeTapped(type: .new)
                                    }
                                    RecruitTypeButton(type: .old, currentType: $vm.interviewInfo.recruitType) {
                                        vm.recruitTypeTapped(type: .old)
                                    }
                                }
                            }

                            // === Company Type
                            VStack(spacing: ACLayout.Spacing.medium) {
                                AppSectionHeader(
                                    icon: ACIcon.Vector.bulletListBlack,
                                    text: "企業区分",
                                    lottie: vm.sectionHeaderLottie)
                                InterviewInfoTypeNavigationLink(
                                    label: vm.interviewInfo.companyType.label) {
                                        CompanyTypeListView(vm: vm)
                                    }
                            }
                            
                            // === Career Type
                            VStack(spacing: ACLayout.Spacing.medium) {
                                AppSectionHeader(
                                    icon: ACIcon.Vector.bulletListBlack,
                                    text: "希望職種",
                                    lottie: vm.sectionHeaderLottie)
                                InterviewInfoTypeNavigationLink(
                                    label: vm.interviewInfo.careerType.label) {
                                        CareerTypeListView(vm: vm)
                                    }
                            }
                        }
                    }
                    
                    // === Submit
                    AppSection {
                        GradientRowButton(
                            title: "この内容で進める",
                            icon: ACIcon.Vector.selfieWhite,
                            lottie: vm.gradientRowButtonLottie) {
                                vm.submitButtonTapped {
                                    nc.path.append(.interviewView)
                                    Task {
                                        await interviewOrchestrator.prepare(info: .init(from: vm.interviewInfo))
                                    }
                                }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
            .toast(isPresenting: $vm.isShowFieldInvalidToast) {
                AlertToast(
                    displayMode: .hud,
                    type: .error(ACColor.Status.warning),
                    title: "無効な項目があります")
            }
            
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { focus = nil }
                .allowsHitTesting(focus == .companyName)
        }
        .navigationTitle(vm.navigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBarDismiss {
                    dismiss()
                }
            }
        }
        .onDisappear {
            vm.interviewInfoFormDisappear()
        }
    }
}

#Preview {
    InterviewInfoFormView()
}
