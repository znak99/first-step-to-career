//
//  InterviewPrepareInteractor.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/31.
//

import Foundation

// 카메라, 마이크, 음성인식 권한 확인
// 회사명, 채용구분, 회사타입, 희망직종을 메모리에 저장
// 위의 정보를 이용하여 첫 질문을 생성해둠
public final class InterviewPrepareInteractor: InterviewUsecase {
    public func execute(_ req: InterviewContext) async throws -> InterviewQuestion? {
        return nil
    }
}
