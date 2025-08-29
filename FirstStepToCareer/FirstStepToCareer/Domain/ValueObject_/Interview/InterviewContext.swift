//
//  InterviewContext.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

struct InterviewContext: Sendable {
    var companyName: String
    var recruitType: String
    var companyType: String
    var careerType: String
    
    init(from info: InterviewInfo) {
        self.companyName = info.companyName
        self.recruitType = info.recruitType.label
        self.companyType = info.companyType.label
        self.careerType = info.careerType.label
    }
}
