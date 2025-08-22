//
//  InterviewPrepareView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

import SwiftUI
import Shimmer

struct InterviewPrepareView: View {
    @StateObject private var vm = InterviewPrepareViewModel()
    @FocusState private var focus: FocusTarget?
    @EnvironmentObject private var nc: NavigationController
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack {
                        HStack(alignment: .top) {
                            Image(InterviewPrepareIcon.headerCaption)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("模擬面接用の企業情報なので\n実在の会社じゃなくてもOKです！")
                                .appCaptionStyle()
                        }
                        HStack(alignment: .top) {
                            Image(InterviewPrepareIcon.headerCaption)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("ただ、企業名以外の項目は模擬面接の質問に影響します！")
                                .appCaptionStyle()
                        }
                    }
                    .padding(.vertical)
                    AppSection {
                        VStack(spacing: 8) {
                            AppSectionHeader(
                                icon: InterviewPrepareIcon.CompanyName.header,
                                text: "企業名",
                                lottie: vm.sectionHeaderLottie)
                            CustomTextField(
                                placeholder: "株式会社就活一歩",
                                text: $vm.interviewInfo.companyName,
                                focus: $focus,
                                focusTarget: .companyName)
                        }
                        
                        VStack(spacing: 8) {
                            AppSectionHeader(
                                icon: vm.interviewInfo.recruitType == .new
                                ? InterviewPrepareIcon.RecruitType.headerL
                                : InterviewPrepareIcon.RecruitType.headerR,
                                text: "選考区分",
                                lottie: vm.sectionHeaderLottie)
                            HStack {
                                InterviewPrepareRecruitTypeButton(
                                    icon: SFSymbolsIcon.graduationcapFill,
                                    type: .new,
                                    vm: vm
                                )
                                .tapScaleEffect()
                                InterviewPrepareRecruitTypeButton(
                                    icon: SFSymbolsIcon.suitcaseFill,
                                    type: .old,
                                    vm: vm
                                )
                            }
                        }
                        .padding(.top)

                        VStack(spacing: 8) {
                            AppSectionHeader(
                                icon: InterviewPrepareIcon.CompanyType.header,
                                text: "企業区分",
                                lottie: vm.sectionHeaderLottie)
                            NavigationLink(destination: InterviewInfoCompanyTypeListView(vm: vm)) {
                                HStack {
                                    Text(vm.interviewInfo.companyType.rawValue)
                                        .font(.custom(Font.appMedium, size: 16))
                                    Spacer()
                                    Image(systemName: SFSymbolsIcon.chevronRight)
                                }
                                .padding(8)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
                            }
                            .tapScaleEffect()
                        }
                        .padding(.top)
                        
                        VStack(spacing: 8) {
                            AppSectionHeader(
                                icon: InterviewPrepareIcon.CareerType.header,
                                text: "希望職種",
                                lottie: vm.sectionHeaderLottie)
                            NavigationLink(destination: InterviewInfoCareerTypeListView(vm: vm)) {
                                HStack {
                                    Text(vm.interviewInfo.careerType.rawValue)
                                        .font(.custom(Font.appMedium, size: 16))
                                    Spacer()
                                    Image(systemName: SFSymbolsIcon.chevronRight)
                                }
                                .padding(8)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
                            }
                            .tapScaleEffect()
                        }
                        .padding(.top)
                    }
                    AppSection {
                        GradientNavigationButton(title: "この内容で進める", icon: InterviewPrepareIcon.nav) {
                            navigate(.interviewView)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    focus = nil
                }
                .allowsHitTesting(focus == .companyName)
        }
        .navigationTitle("模擬面接情報")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        dismiss()
                    },
                    label: {
                        Image(systemName: SFSymbolsIcon.chevronLeft)
                            .foregroundStyle(Color.black)
                    }
                )
            }
        }
        .onDisappear {
            vm.sectionHeaderLottie = nil
        }
    }
    
    private func navigate(_ page: Route) {
        if vm.interviewInfo.isValidInterviewInfo() {
            vm.sectionHeaderLottie = LottieAnimation.circleCheck
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                nc.pagePath.append(page)
            }
        }
    }
}

#Preview {
    InterviewPrepareView()
}
