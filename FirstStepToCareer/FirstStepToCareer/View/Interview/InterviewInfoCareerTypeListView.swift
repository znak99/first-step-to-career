//
//  InterviewInfoCareerTypeListView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct InterviewInfoCareerTypeListView: View {
    // MARK: - Variables
    @ObservedObject var interviewVM: InterviewViewModel
    @EnvironmentObject private var nc: NavigationController
    
    // MARK: - UI
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                Text("希望している職種を\n選んでください")
                    .font(.custom(Font.appBold, size: 20, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                ScrollView {
                    ForEach(CareerType.allCases) { type in
                        if type != .none {
                            Button(
                                action: {
                                    interviewVM.mockInterviewInfo.careerType = type
                                    nc.pagePath.removeAll()
                                },
                                label: {
                                    HStack {
                                        GeometryReader { proxy in
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.appAccentColor)
                                                .frame(width: proxy.size.width)
                                        }
                                        .frame(maxWidth: 12, maxHeight: 40)
                                        Text(type.rawValue)
                                            .font(.custom(Font.appMedium, size: 16, relativeTo: .subheadline))
                                        Spacer()
                                        Image(systemName: AppConstants.chevronRight)
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
        .navigationBarBackButtonHidden(true) // FIXME: - 스와이프로 디스미스가 안됌
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        nc.pagePath.removeAll()
                    },
                    label: {
                        Image(systemName: AppConstants.chevronLeft)
                            .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                            .foregroundStyle(.black)
                    }
                )
            }
            
            ToolbarItem(placement: .principal) {
                Text("職種選択")
                    .font(.custom(Font.appBold, size: 16, relativeTo: .subheadline))
            }
        }
        .onDisappear {
            nc.pagePath.removeAll()
        }
    }
}

#Preview {
    InterviewInfoCareerTypeListView(interviewVM: InterviewViewModel())
}
