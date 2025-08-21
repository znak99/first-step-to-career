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
                    CustomTextField(
                        placeholder: "株式会社就活一歩",
                        text: $text,
                        focus: $focus,
                        focusTarget: .companyName)
                    AppSectionHeader(icon: InterviewTabIcon.header, text: "企業区分")
                    CustomTextField(
                        placeholder: "株式会社就活一歩",
                        text: $text,
                        focus: $focus,
                        focusTarget: .companyName)
                    AppSectionHeader(icon: InterviewTabIcon.header, text: "希望職種")
                    CustomTextField(
                        placeholder: "株式会社就活一歩",
                        text: $text,
                        focus: $focus,
                        focusTarget: .companyName)
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
                        
                    },
                    label: {
                        
                    }
                )
            }
        }
        .onDisappear {
            nc.pagePath.removeLast()
        }
    }
}

#Preview {
    InterviewPrepareView()
}
