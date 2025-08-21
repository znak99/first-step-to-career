//
//  InterviewPrepareView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

import SwiftUI

struct InterviewPrepareView: View {
    @FocusState private var focus: FocusTarget?
    @EnvironmentObject private var nc: NavigationController
    @State var text = ""
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack {
                AppSection {
                    AppSectionHeader(icon: InterviewTabIcon.header, text: "会社名")
                    CustomTextField(
                        placeholder: "株式会社就活一歩",
                        text: $text,
                        focus: $focus,
                        focusTarget: .companyName)
                    AppSectionHeader(icon: InterviewTabIcon.header, text: "選考区分")
                    GradientNavigationButton(title: "この内容で進める", icon: InterviewTabIcon.Interview.focus) {
                        nc.pagePath.append(.interviewView)
                    }
                    AppSectionHeader(icon: InterviewTabIcon.header, text: "企業区分")
                    GradientNavigationButton(title: "この内容で進める", icon: InterviewTabIcon.Interview.focus) {
                        nc.pagePath.append(.interviewView)
                    }
                    AppSectionHeader(icon: InterviewTabIcon.header, text: "希望職種")
                    GradientNavigationButton(title: "この内容で進める", icon: InterviewTabIcon.Interview.focus) {
                        nc.pagePath.append(.interviewView)
                    }
                }
                AppSection {
                    GradientNavigationButton(title: "この内容で進める", icon: InterviewTabIcon.Interview.focus) {
                        nc.pagePath.append(.interviewView)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        nc.pagePath.removeLast()
                    },
                    label: {
                        Image(systemName: SFSymbolsIcon.chevronLeft)
                    }
                )
            }
            ToolbarItem(placement: .navigation) {
                Text("Interview")
            }
        }
        .onDisappear() {
            if !nc.pagePath.isEmpty {
                nc.pagePath.removeLast()
            }
        }
    }
}

#Preview {
    InterviewPrepareView()
}
