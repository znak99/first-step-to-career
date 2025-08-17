//
//  InterviewViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

class InterviewViewModel: ObservableObject {
    // MARK: - Variables
    @Published var mockInterviewInfo: MockInterviewInfo = .init()
    @Published var bestResult: MockInterviewResult?
    
    // MARK: - Functions
    // Date객체를 문자열 yyyy/MM/dd포맷으로 변환하는 함수
    // - Returns: 모의면접의 필요한 정보가 모두 입력됬는지 여부
    func isValidMockInterviewInfo() -> Bool {
        if mockInterviewInfo.companyName.isEmpty { // 회사이름 입력여부
            return false
        }
        
        if mockInterviewInfo.companyType == .none { // 회사분야 선택여부
            return false
        }
        
        if mockInterviewInfo.careerType == .none { // 희망직종 선택여부
            return false
        }
        
        return true
    }
}
