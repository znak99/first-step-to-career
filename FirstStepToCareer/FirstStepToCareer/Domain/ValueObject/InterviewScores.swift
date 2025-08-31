//
//  InterviewScores.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

// Path: Domain/ValueObjects/InterviewScores.swift
/// 인터뷰 메트릭 점수화 결과
struct InterviewScores: Sendable {
    /// 말의 빠르기 (적절할수록 높은 점수)
    var speechSpeed: Double
    
    /// 침묵 비율/시간 (짧을수록 높은 점수)
    var silence: Double
    
    /// 얼굴 방향 정면 유지 정도
    var headDirection: Double
    
    /// 전체 총합 (가중치 합산)
    var total: Double
}
