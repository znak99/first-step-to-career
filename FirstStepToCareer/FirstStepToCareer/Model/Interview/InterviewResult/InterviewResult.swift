//
//  InterviewResult.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

import Foundation
import FirebaseFirestore

struct InterviewResult: Identifiable, Codable {
    // Firestore
    @DocumentID var id: String?
    let userID: String
    let sessionID: String
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?

    // 메타 데이터
    var companyName: String
    let recruitType: String
    let companyType: String
    let careerType: String
    let startedAt: Date
    let schemaVersion: Int

    // 질문-답변 리스트
    let turns: [InterviewTurn]

    // 총 평가
    let overall: OverallMetrics

    // 정렬/검색 키
    let sortKey: Int?
}
