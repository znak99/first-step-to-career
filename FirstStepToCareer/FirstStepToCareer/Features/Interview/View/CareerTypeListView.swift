//
//  CareerTypeListView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct CareerTypeListView: View {
    // MARK: - Properties
    @ObservedObject var vm: InterviewInfoFormViewModel
    @EnvironmentObject private var nc: NavigationController
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ACColor.Brand.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                Text("希望している職種を\n選んでください")
                    .font(.custom(ACFont.Weight.bold, size: ACFont.Size.medium, relativeTo: .title))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, ACLayout.Padding.small)
                
                ScrollView {
                    ForEach(CareerType.allCases) { type in
                        if type != .none {
                            Button(
                                action: { vm.careerTypeTapped(type: type) },
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
        .navigationTitle("希望職種選択")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBarDismiss {
                    dismiss()
                }
            }
        }
        .onChange(of: vm.isCareerTypeListDismiss, { _, newValue in
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
    CareerTypeListView(vm: InterviewInfoFormViewModel())
}
