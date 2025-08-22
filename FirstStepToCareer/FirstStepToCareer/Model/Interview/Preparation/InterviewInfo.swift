//
//  InterviewInfo.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation

struct InterviewInfo {
    var companyName: String = ""
    var recruitType: RecruitType = .new
    var companyType: CompanyType = .none
    var careerType: CareerType = .none
    
    func isValidInterviewInfo() -> Bool {
        if companyName.isEmpty {
            return false
        }
        
        if companyType == .none {
            return false
        }
        
        if careerType == .none {
            return false
        }
        
        return true
    }
}
