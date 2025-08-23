//
//  InterviewMockDataGenerator.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/19.
//

import Foundation
import FirebaseFirestore

// MARK: - 테스트 데이터 생성기 (요청 반영 버전)
struct InterviewMockDataGenerator {
    static func makeInterviewResults(count: Int = 10) -> [InterviewResult] {
        (0..<count).map { _ in
            makeInterviewResult()
        }
    }

    // MARK: InterviewResult 1개 생성
    private static func makeInterviewResult() -> InterviewResult {
        // 인터뷰 시작 시간: 최근 30일 내 랜덤
        let interviewStart = Date().addingTimeInterval(-Double.random(in: 0...(60*60*24*30)))

        // Firestore Timestamp 랜덤 (updatedAt >= createdAt)
        let createdDate = interviewStart.addingTimeInterval(Double.random(in: 0...(60*30))) // 시작 후 ~30분
        let updatedDate = createdDate.addingTimeInterval(Double.random(in: 0...(60*60*3)))  // created 이후 ~3시간
        let createdAt = Timestamp(date: createdDate)
        let updatedAt = Timestamp(date: updatedDate)

        let turnCount = Int.random(in: 3...7)
        let turns = makeTurns(interviewStart: interviewStart, count: turnCount)

        // 턴 점수로부터 평균 계산 (더 그럴듯하게)
        let overall = makeOverall(from: turns)

        return InterviewResult(
            id: nil, // Firestore에 쓰는 테스트라면 nil이 자연스러움 (@DocumentID)
            userID: UUID().uuidString,
            sessionID: UUID().uuidString,
            createdAt: createdAt,
            updatedAt: updatedAt,
            companyName: ["トヨタ", "ソニー", "楽天", "メルカリ", "サイバーエージェント", "DeNA", "LINEヤフー"].randomElement()!,
            recruitType: ["新卒", "中途", "インターン"].randomElement()!,
            companyType: ["SIer", "事業会社", "スタートアップ", "受託"].randomElement()!,
            careerType: ["iOSエンジニア", "サーバーサイド", "機械学習", "QAエンジニア"].randomElement()!,
            startedAt: interviewStart,
            schemaVersion: 1,
            turns: turns,
            overall: overall,
            sortKey: Int(-interviewStart.timeIntervalSince1970)
        )
    }

    // MARK: - 턴들을 인터뷰 플로우 순으로 생성
    private static func makeTurns(interviewStart: Date, count: Int) -> [InterviewTurn] {
        var turns: [InterviewTurn] = []
        var cursor = interviewStart

        let questionPool = [
            "自己紹介をお願いします",
            "学生時代に力を入れたことは？",
            "志望動機を教えてください",
            "長所と短所を教えてください",
            "困難を乗り越えた経験は？",
            "チームでの役割は？",
            "入社後に挑戦したいことは？"
        ]

        for _ in 0..<count {
            let duration = Double.random(in: 20...120)           // 답변 길이 20~120초
            let start = cursor
            let end = start.addingTimeInterval(duration)
            // 턴과 턴 사이 짧은 휴식(5~20초)을 두고 다음 턴 시작
            let betweenGap = Double.random(in: 5...20)
            cursor = end.addingTimeInterval(betweenGap)

            // 메트릭 생성 (비율 = 시간/전체시간 으로 일관성 유지)
            let silenceSec = Double.random(in: 0...(duration * 0.5))
            let headOffSec = Double.random(in: 0...(duration * 0.5))
            let gazeOffSec = Double.random(in: 0...(duration * 0.5))

            let speech = SpeechSpeedMetric(
                speed: Double.random(in: 120...280),          // ex) wpm 또는 앱 기준 단위
                score: Double.random(in: 0...10)
            )
            let silence = SilenceMetric(
                silenceSec: silenceSec,
                ratio: max(0, min(1, silenceSec / duration)),
                score: Double.random(in: 0...10)
            )
            let head = HeadDirectionMetric(
                offFrontSec: headOffSec,
                offFrontRatio: max(0, min(1, headOffSec / duration)),
                score: Double.random(in: 0...10)
            )
            let gaze = GazeMetric(
                offCenterSec: gazeOffSec,
                offCenterRatio: max(0, min(1, gazeOffSec / duration)),
                score: Double.random(in: 0...10)
            )

            // 0.5s 간격 표정 샘플
            let samples = makeExpressionSamples(duration: duration)
            let expression = ExpressionMetric(
                samples: samples,
                score: Double.random(in: 0...10)
            )

            let turn = InterviewTurn(
                id: UUID().uuidString,
                questionId: UUID().uuidString,
                questionText: questionPool.randomElement()!,
                answerText: ["はい、私は〜", "私の強みは〜", "御社を志望する理由は〜", "結論から申しますと〜"].randomElement(),
                answerDurationSec: duration,
                startedAt: start,
                endedAt: end,
                speechSpeed: speech,
                silence: silence,
                headDirection: head,
                gaze: gaze,
                expression: expression
            )
            turns.append(turn)
        }
        return turns
    }

    // MARK: - 0.5초 간격 표정 샘플 생성
    private static func makeExpressionSamples(duration: Double) -> [ExpressionSample] {
        let labels = ["neutral", "smile", "frown", "surprised"]
        let count = Int((duration / 0.5).rounded(.down)) + 1
        return (0..<count).map { i in
            ExpressionSample(
                timeOffsetSec: Double(i) * 0.5,
                label: labels.randomElement()!
            )
        }
    }

    // MARK: - 턴 점수 평균으로 Overall 계산
    private static func makeOverall(from turns: [InterviewTurn]) -> OverallMetrics {
        func avg(_ values: [Double?]) -> Double? {
            let xs = values.compactMap { $0 }
            guard !xs.isEmpty else { return nil }
            return xs.reduce(0, +) / Double(xs.count)
        }

        let avgSpeech = avg(turns.map { $0.speechSpeed?.score })
        let avgSilence = avg(turns.map { $0.silence?.score })
        let avgHead   = avg(turns.map { $0.headDirection?.score })
        let avgGaze   = avg(turns.map { $0.gaze?.score })
        let avgExpr   = avg(turns.map { $0.expression?.score })

        // 단순 평균으로 totalScore (필요시 가중치 반영 가능)
        let components = [avgSpeech, avgSilence, avgHead, avgGaze, avgExpr].compactMap { $0 }
        let total = components.isEmpty ? nil : (components.reduce(0, +) / Double(components.count))

        return OverallMetrics(
            avgSpeechSpeedScore: avgSpeech!,
            avgSilenceScore: avgSilence!,
            avgHeadDirectionScore: avgHead!,
            avgGazeScore: avgGaze!,
            avgExpressionScore: avgExpr!,
            totalScore: total!,
            feedBack: "It was good"
        )
    }
}
