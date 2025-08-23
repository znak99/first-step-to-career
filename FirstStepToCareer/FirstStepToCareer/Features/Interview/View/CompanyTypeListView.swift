//
//  CompanyTypeListView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct CompanyTypeListView: View {
    // MARK: - Properties
    @ObservedObject var vm: InterviewInfoFormViewModel
    @EnvironmentObject private var nc: NavigationController
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Text("応募する企業の分野を\n選んでください")
                    .font(.custom(ACFont.Weight.bold, size: ACFont.Size.medium, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, ACLayout.Padding.small)
                
                ScrollView {
                    ForEach(CompanyType.allCases) { type in
                        if type != .none {
                            Button(
                                action: { vm.companyTypeTapped(type: type) },
                                label: {
                                    HStack {
                                        Text(type.label)
                                            .font(.custom(
                                                ACFont.Weight.medium,
                                                size: ACFont.Size.small,
                                                relativeTo: .subheadline))
                                        Spacer()
                                        Image(ACIcon.Vector.angleRightBlack)
                                            .resizable()
                                            .scaledToFit()
                                            .smallFrame(alignment: .center)
                                    }
                                    .foregroundStyle(ACColor.Font.black)
                                }
                            )
                            .tapScaleEffect()
                            .padding(.top, ACLayout.Padding.large)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
        .navigationTitle("企業区分選択")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBarDismiss {
                    dismiss()
                }
            }
        }
        .onChange(of: vm.isCompanyTypeListDismiss, { _, newValue in
            if newValue {
                dismiss()
            }
        })
        .onDisappear {
            vm.typeListDisappear()
        }
    }
}

#Preview {
    CompanyTypeListView(vm: InterviewInfoFormViewModel())
}
