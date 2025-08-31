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

extension InterviewUsecase where Req == Void {
    func execute() async throws -> Res {
        try await execute(())
    }
}

extension InterviewUsecase where Res == Void {
    func execute(_ req: Req) async throws {
        try await execute(req)
    }
}

extension InterviewUsecase where Req == Void, Res == Void {
    func execute() async throws {
        try await execute(())
    }
}
