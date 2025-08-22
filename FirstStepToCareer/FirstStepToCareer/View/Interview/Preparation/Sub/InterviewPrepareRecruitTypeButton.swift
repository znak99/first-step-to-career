//
//  InterviewPrepareRecruitTypeButton.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/22.
//

import SwiftUI

struct InterviewPrepareRecruitTypeButton: View {
    let icon: String
    let type: RecruitType
    @ObservedObject var vm: InterviewPrepareViewModel
    
    var body: some View {
        Button(
            action: {
                vm.interviewInfo.recruitType = type
            },
            label: {
                HStack {
                    Image(systemName: icon)
                        .font(.subheadline)
                    Text(type.label)
                        .font(.custom(Font.appMedium, size: 16))
                }
                .frame(maxWidth: .infinity)
                .padding(6)
                .foregroundStyle(vm.interviewInfo.recruitType == type
                                 ? .white : .black)
                .background {
                    LinearGradient(
                        colors: [
                            vm.interviewInfo.recruitType == type
                            ? Color.appMainGradientStart : Color.appBackground,
                            vm.interviewInfo.recruitType == type
                            ? Color.appMainGradientEnd : Color.appBackground
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: AppConstant.Radius.box))
            }
        )
        .tapScaleEffect()
    }
}

#Preview {
    InterviewPrepareRecruitTypeButton(
        icon: SFSymbolsIcon.graduationcapFill,
        type: .new,
        vm: InterviewPrepareViewModel())
}
