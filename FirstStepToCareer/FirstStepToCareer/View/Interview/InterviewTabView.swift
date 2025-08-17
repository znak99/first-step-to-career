//
//  InterviewTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewTabView: View {
    // MARK: - Variables
    @StateObject var interviewVM = InterviewViewModel()
    @EnvironmentObject private var nc: NavigationController
    @FocusState private var focus: FocusTarget?
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            Color.appBackground.ignoresSafeArea()
            // Main Contents
            VStack {
                // Header
                TabViewHeader(
                    icon: "video.fill",
                    iconRotateDegrees: -10,
                    title: "Mock Interview",
                    caption: "模擬面接で本番を想定した練習をすれば\n落ち着いて話せて自分らしさをしっかり伝えられます！"
                )
                // Scroll View
                ScrollView(.vertical) {
                    // History
                    VStack {
                        if let bestResult = interviewVM.bestResult {
                            interviewResultBox(bestResult: bestResult)
                        } else {
                            noInterviewResultLoginBox()
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
                        .appCaptionStyle()
                    VStack {
                        VStack {
                            // Company Name
                            inputFormCompanyName()
                            
                            // Recruit Type
                            inputFormRecruitType()
                            
                            // Company Type
                            inputFormCompanyType()
                            
                            // CareerType
                            inputFormCareerType()
                            
                            Divider()
                            
                            NavigationButton(
                                label: "模擬面接を始める",
                                isLabelCenter: true,
                                fontWeight: Font.appMedium,
                                textColor: Color.white,
                                backgroundColor: Color.appAccentColor,
                                verticalPadding: 8) {
                                    if interviewVM.isValidMockInterviewInfo() {
                                        nc.pagePath.append(.mockInterviewPrepareView)
                                    } else {
                                        // TODO: - 정보입력하라는 Alert 띄우기
                                    }
                                }
                                .tapScaleEffect()
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
            .navigationDestination(for: AppPage.self) { page in
                switch page {
                case .interviewInfoCompanyTypeListView:
                    InterviewInfoCompanyTypeListView(interviewVM: interviewVM)
                case .interviewInfoCareerTypeListView:
                    InterviewInfoCareerTypeListView(interviewVM: interviewVM)
                case .mockInterviewPrepareView:
                    MockInterviewPrepareView(interviewVM: interviewVM)
                default:
                    EmptyView()
                }
            }
            
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

// MARK: - Sub View
private extension InterviewTabView {
    @ViewBuilder
    func interviewResultBox(bestResult: MockInterviewResult) -> some View {
        Button(
            action: { // TODO: - 모의면접 상세화면(최고점수)으로 Navigation 처리하기
                
            },
            label: {
                VStack {
                    Text("この模擬面接すごく良かったです！👍")
                        .appCaptionStyle()
                    HStack(alignment: .firstTextBaseline) {
                        Text(bestResult.companyName.truncated(24))
                            .font(.custom(Font.appBold, size: 20, relativeTo: .title))
                        Spacer()
                        Text(AppConstants.formatDate(bestResult.createdAt))
                            .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                            .foregroundStyle(Color.appGrayFont)
                    }
                    HStack {
                        VStack(alignment: .center) {
                            Image(systemName: "building.2.fill")
                            Image(systemName: bestResult.recruitType == RecruitType.new.label ?
                                  RecruitType.new.icon : RecruitType.old.icon)
                        }
                        .font(.footnote)
                        VStack(alignment: .leading) {
                            Text(bestResult.companyType)
                            Text(bestResult.recruitType)
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
                            Text("\(String(format: "%.1f", bestResult.score))")
                                .font(.custom(Font.appSemiBold, size: 16))
                        }
                        .frame(width: 40, height: 40)
                        Text("点")
                            .font(.custom(Font.appBold, size: 20, relativeTo: .subheadline))
                        Spacer()
                        Text("詳細はここ！👆")
                            .appCaptionStyle()
                            .foregroundStyle(Color.black)
                    }
                }
            }
        )
        .foregroundStyle(.black)
        .tapScaleEffect()
        Divider()
        Button(
            action: { // TODO: - 과거모의면접리스트화면으로 Navigation 처리하기
                
            },
            label: {
                HStack {
                    Text("過去の模擬面接を見る")
                        .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                    Spacer()
                    Image(systemName: AppConstants.chevronRight)
                        .font(.subheadline)
                        .fontWeight(.regular)
                }
            }
        )
        .foregroundStyle(.black)
    }
    
    @ViewBuilder
    func noInterviewResultLoginBox() -> some View {
        VStack {
            Text("模擬面接データがないようですね\nログインすると過去の模擬面接が確認できます！")
                .appCaptionStyle()
            NavigationButton(
                label: "ログインする",
                isLabelCenter: true,
                fontWeight: Font.appSemiBold,
                textColor: Color.white,
                backgroundColor: Color.appAccentColor,
                verticalPadding: 4) { // TODO: - 로그인화면으로 Navigation 처리하기
                    
                }
                .tapScaleEffect()
        }
    }
}

private extension InterviewTabView {
    @ViewBuilder
    func inputFormCompanyName() -> some View {
        VStack(spacing: 2) {
            inputFormTitle(title: "会社名", isRequired: true)
            ZStack(alignment: .leading) {
                if interviewVM.mockInterviewInfo.companyName.isEmpty {
                    Text("株式会社就活一歩")
                        .foregroundColor(.gray)
                        .offset(y: 0)
                }
                TextField("", text: $interviewVM.mockInterviewInfo.companyName)
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
    }
    
    @ViewBuilder
    func inputFormRecruitType() -> some View {
        VStack(spacing: 2) {
            inputFormTitle(title: "活動区分", isRequired: true)
            HStack(spacing: 24) {
                inputFormRecruitTypeButton(isNew: true)
                    .tapScaleEffect()
                inputFormRecruitTypeButton(isNew: false)
                    .tapScaleEffect()
            }
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    func inputFormCompanyType() -> some View {
        VStack(spacing: 2) {
            inputFormTitle(title: "企業分野", isRequired: true)
            NavigationButton(
                label: interviewVM.mockInterviewInfo.companyType.rawValue,
                isLabelCenter: false,
                fontWeight: Font.appRegular,
                textColor: Color.black,
                backgroundColor: Color.white,
                verticalPadding: 4) {
                    nc.pagePath.append(.interviewInfoCompanyTypeListView)
                }
                .tapScaleEffect()
        }
    }
    
    @ViewBuilder
    func inputFormCareerType() -> some View {
        VStack(spacing: 2) {
            inputFormTitle(title: "希望職種", isRequired: true)
            NavigationButton(
                label: interviewVM.mockInterviewInfo.careerType.rawValue,
                isLabelCenter: false,
                fontWeight: Font.appRegular,
                textColor: Color.black,
                backgroundColor: Color.white,
                verticalPadding: 4) {
                    nc.pagePath.append(.interviewInfoCareerTypeListView)
                }
                .tapScaleEffect()
        }
    }
}

// MARK: - Recycle Sub View
private extension InterviewTabView {
    @ViewBuilder
    func inputFormTitle(title: String, isRequired: Bool) -> some View {
        HStack {
            Circle()
                .frame(width: 4, height: 4)
            Text(title)
                .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
            Text(isRequired ? "（必須）" : "（任意）")
                .font(.custom(Font.appRegular, size: 12, relativeTo: .subheadline))
                .foregroundStyle(Color.appGrayFont)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension InterviewTabView {
    @ViewBuilder
    func inputFormRecruitTypeButton(isNew: Bool) -> some View {
        let type = isNew ? RecruitType.new : RecruitType.old
        
        Button(
            action: {
                if isNew {
                    interviewVM.mockInterviewInfo.recruitType = .new
                } else {
                    interviewVM.mockInterviewInfo.recruitType = .old
                }
            },
            label: {
                HStack {
                    Image(systemName: isNew ? RecruitType.new.icon : RecruitType.old.icon)
                        .font(.subheadline)
                    Text(isNew ? RecruitType.new.label : RecruitType.old.label)
                        .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                }
                .frame(maxWidth: .infinity)
            }
        )
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(type == interviewVM.mockInterviewInfo.recruitType
                    ? Color.appAccentColor : Color.appBackground)
        .foregroundStyle(type == interviewVM.mockInterviewInfo.recruitType ? .white : .black)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.buttonRadius))
    }
}
// MARK: - Preview
#Preview {
    InterviewTabView()
        .environmentObject(NavigationController())
}
