//
//  InterviewUsecase.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/31.
//

import Foundation

protocol InterviewUsecase {
    associatedtype Req
    associatedtype Res
    
    func execute(_ req: Req) async throws -> Res
}
