//
//  EvaluationPolicy.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

struct EvaluationPolicy: Sendable {
    let version: String

    struct Weights: Sendable {
        var speechSpeed: Double = 0.20
        var silence: Double     = 0.20
        var headDirection: Double = 0.20
        var gaze: Double        = 0.20
        var expression: Double  = 0.20

        var sum: Double { speechSpeed + silence + headDirection + gaze + expression }
    }

    /// 이상적 범위를 담는 구조체 (필요 시 조정)
    struct Targets: Sendable {
        // 말 빠르기: 너무 느림/빠름 컷오프, 이상적 고원 구간
        var speechHardMin: Double = 70      // WPM 이 값 이하면 0점
        var speechIdealMin: Double = 110    // 이상적 구간 시작
        var speechIdealMax: Double = 160    // 이상적 구간 끝
        var speechHardMax: Double = 210     // WPM 이 값 이상이면 0점

        // 침묵 비율: 낮을수록 좋음. 이상적 구간은 5%~15% 정도로 가정
        var silenceIdealMin: Double = 0.05
        var silenceIdealMax: Double = 0.15
        var silenceHardMax: Double = 0.60    // 이 이상이면 0점

        // 시선/머리방향 유지 비율(0..1)
        var gazeIdealMin: Double = 0.80      // 80% 이상이면 고득점
        var gazeHardMin: Double = 0.30       // 30% 미만이면 0점
    }

    var weights: Weights
    var targets: Targets

    init(version: String = "v1",
                weights: Weights = Weights(),
                targets: Targets = Targets()) {
        self.version = version
        self.weights = weights
        self.targets = targets
    }
}
