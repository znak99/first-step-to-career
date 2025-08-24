//
//  InterviewInfoFormViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/22.
//

import SwiftUI

@MainActor
final class InterviewInfoFormViewModel: ObservableObject {
    // MARK: - Properties
    @Published var interviewInfo: InterviewInfo = .init()
    @Published var sectionHeaderLottie: String?
    @Published var navigationBarTitle: String = "模擬面接情報"
    @Published var isShowFieldInvalidToast: Bool = false
    @Published var isCompanyTypeListDismiss: Bool = false
    @Published var isCareerTypeListDismiss: Bool = false
    @Published var isSubmitButtonDisable: Bool = false
    
    // MARK: - Actions
    func recruitTypeTapped(type: RecruitType) {
        interviewInfo.recruitType = type
    }
    
    func companyTypeTapped(type: CompanyType) {
        interviewInfo.companyType = type
        isCompanyTypeListDismiss = true
    }
    
    func careerTypeTapped(type: CareerType) {
        interviewInfo.careerType = type
        isCareerTypeListDismiss = true
    }
    
    func typeListDisappear() {
        isCompanyTypeListDismiss = false
        isCareerTypeListDismiss = false
    }
    
    func submitButtonTapped(completion: @escaping () -> Void) {
        if isSubmitButtonDisable {
           return
        }
        isSubmitButtonDisable = true
        
        isShowFieldInvalidToast = !interviewInfo.isValidInterviewInfo()
        if isShowFieldInvalidToast {
            navigationBarTitle = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                self.navigationBarTitle = "模擬面接情報"
                self.isSubmitButtonDisable = false
            }
            return
        }
        
        sectionHeaderLottie = ACLottie.checkCircle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isSubmitButtonDisable = false
            completion()
        }
    }
    
    func interviewInfoFormDisappear() {
        sectionHeaderLottie = nil
    }
}
