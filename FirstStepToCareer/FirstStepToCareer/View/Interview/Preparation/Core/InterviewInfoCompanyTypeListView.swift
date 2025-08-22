//
//  InterviewInfoCompanyTypeListView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct InterviewInfoCompanyTypeListView: View {
    // MARK: - Variables
    @ObservedObject var vm: InterviewPrepareViewModel
    @EnvironmentObject private var nc: NavigationController
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - UI
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                Text("応募する企業の分野を\n選んでください")
                    .font(.custom(Font.appBold, size: 20, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                ScrollView {
                    ForEach(CompanyType.allCases) { type in
                        if type != .none {
                            Button(
                                action: {
                                    vm.interviewInfo.companyType = type
                                    dismiss()
                                },
                                label: {
                                    HStack {
                                        GeometryReader { proxy in
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.appPrimary)
                                                .frame(width: proxy.size.width)
                                        }
                                        .frame(maxWidth: 12, maxHeight: 40)
                                        Text(type.rawValue)
                                            .font(.custom(Font.appMedium, size: 16, relativeTo: .subheadline))
                                        Spacer()
                                        Image(systemName: SFSymbolsIcon.chevronRight)
                                    }
                                    .foregroundStyle(.black)
                                }
                            )
                            .padding(.top)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("企業区分選択")
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
                            .foregroundStyle(.black)
                    }
                )
            }
        }
    }
}

#Preview {
    InterviewInfoCompanyTypeListView(vm: InterviewPrepareViewModel())
}
