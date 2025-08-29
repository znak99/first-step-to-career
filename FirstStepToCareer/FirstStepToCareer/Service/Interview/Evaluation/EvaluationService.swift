//
//  EvaluationService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

// Path: Services/Evaluation/EvaluationService.swift
import Foundation

// MetricEvaluating 프로토콜 가정:
// @MainActor
// protocol MetricEvaluating: Sendable {
//     var policyVersion: String { get }
//     func evaluate(session: SessionMetrics) -> InterviewScores
// }

/// 기본 정책을 적용한 평가기
struct EvaluationService: MetricEvaluating, Sendable {
    
    let policyVersion: String
    let policy: EvaluationPolicy
    
    init(policy: EvaluationPolicy = EvaluationPolicy()) {
        self.policy = policy
        self.policyVersion = policy.version
    }
    
    func evaluate(session: SessionMetrics) async -> InterviewScores {
        let sp = scoreSpeechSpeed(session.speechSpeedWPM)
        let sl = scoreSilence(session.silenceRatio)
        // TODO: headDirection 원시 지표(headOnRatio 등)가 추가되면, 전용 스코어러로 교체
        let gz = scoreGazeLike(session.onTargetGazeRatio)
        let hd = gz // 임시 정책: headDirection = gaze 스코어와 동일
        let ex = clamp01(session.expressionScore / 100.0) * 100.0
        
        let total = weightedAverage([
            (sp, policy.weights.speechSpeed),
            (sl, policy.weights.silence),
            (hd, policy.weights.headDirection),
            (gz, policy.weights.gaze),
            (ex, policy.weights.expression)
        ])
        
        return InterviewScores(
            speechSpeed: sp,
            silence: sl,
            headDirection: hd,
            gaze: gz,
            expression: ex,
            total: total
        )
    }
}

// MARK: - Scoring Functions

private extension EvaluationService {
    /// 말 빠르기: 양쪽 꼬리에서 선형으로 0 → 100로 상승/감소, 이상적 구간은 100점 평지대(plateau)
    func scoreSpeechSpeed(_ wpm: Double) -> Double {
        let t = policy.targets
        if wpm <= t.speechHardMin || wpm >= t.speechHardMax { return 0 }
        if wpm >= t.speechIdealMin && wpm <= t.speechIdealMax { return 100 }
        
        if wpm < t.speechIdealMin {
            // hardMin ~ idealMin 사이: 선형 상승
            return linearMap(x: wpm, x0: t.speechHardMin, x1: t.speechIdealMin, y0: 0, y1: 100)
        } else {
            // idealMax ~ hardMax 사이: 선형 하강
            return linearMap(x: wpm, x0: t.speechIdealMax, x1: t.speechHardMax, y0: 100, y1: 0)
        }
    }
    
    /// 침묵 비율: 0%에 가까우면 가산하되, 완전 0%는 부자연스러울 수 있어
    /// 이상적 구간(예: 5~15%)은 100점, 그 외는 거리 비례로 감점
    func scoreSilence(_ ratio: Double) -> Double {
        let r = clamp01(ratio)
        let t = policy.targets
        
        if r >= t.silenceIdealMin && r <= t.silenceIdealMax { return 100 }
        
        if r < t.silenceIdealMin {
            // 너무 낮음 → idealMin 쪽으로 선형 상승
            return linearMap(x: r, x0: 0.0, x1: t.silenceIdealMin, y0: 70, y1: 100)
            // 0%에 너무 가깝다고 0점 주지 않고 70점부터 시작 (호흡/간투어 여지)
        } else {
            // 너무 높음 → idealMax에서 hardMax까지 선형 하락
            return linearMap(x: r, x0: t.silenceIdealMax, x1: t.silenceHardMax, y0: 100, y1: 0)
        }
    }
    
    /// 시선/머리방향 계열(0..1): hardMin 이하는 0점, idealMin 이상은 100점, 그 사이 선형
    func scoreGazeLike(_ ratio: Double) -> Double {
        let r = clamp01(ratio)
        let t = policy.targets
        
        if r >= t.gazeIdealMin { return 100 }
        if r <= t.gazeHardMin { return 0 }
        
        return linearMap(x: r, x0: t.gazeHardMin, x1: t.gazeIdealMin, y0: 0, y1: 100)
    }
}

// MARK: - Math Helpers

private func clamp01(_ x: Double) -> Double { max(0.0, min(1.0, x)) }

private func linearMap(x: Double, x0: Double, x1: Double, y0: Double, y1: Double) -> Double {
    guard x1 != x0 else { return (y0 + y1) * 0.5 }
    let t = (x - x0) / (x1 - x0)
    let y = y0 + (y1 - y0) * t
    return max(0.0, min(100.0, y))
}

private func weightedAverage(_ pairs: [(Double, Double)]) -> Double {
    let wsum = pairs.reduce(0.0) { $0 + $1.1 }
    guard wsum > 0 else { return 0 }
    let s = pairs.reduce(0.0) { $0 + ($1.0 * $1.1) }
    let v = s / wsum
    return max(0.0, min(100.0, v))
}
