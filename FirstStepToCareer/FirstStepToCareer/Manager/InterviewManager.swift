//
//  InterviewManager.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/22.
//

import Foundation
import SwiftUI

actor InterviewManager: ObservableObject {
    private var interviewInfo: InterviewInfo?
    
    // 마이크와 카메라 권한 확인하기
    func prepare(info: InterviewInfo) {
        interviewInfo = info
        
    }
}
