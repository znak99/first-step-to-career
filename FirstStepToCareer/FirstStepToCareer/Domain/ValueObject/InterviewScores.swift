//
//  InterviewScores.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

struct InterviewScores: Sendable {
    /// 말의 빠르기 (적절할수록 높은 점수)
    var speechSpeed: Double
    
    /// 침묵 비율/시간 (짧을수록 높은 점수)
    var silence: Double
    
    /// 얼굴 방향 정면 유지 정도
    var headDirection: Double
    
    /// 시선 정면 유지 정도
    var gaze: Double
    
    /// 표정 긍정성/자연스러움
    var expression: Double
    
    /// 전체 총합 (가중치 합산)
    var total: Double
}

