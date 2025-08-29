//
//  LocalFeedbackService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation

// TODO: - API 요청 구현하기
struct LocalFeedbackService: FeedbackGenerating, Sendable {
    
    init() {}
    
    func generateFeedback(log: String, context: InterviewContext?) async throws -> InterviewFeedback {
        // 아주 가벼운 휴리스틱 (길이/물음표 개수 등) — LLM 교체 전까지 임시 품질 보강
        let trimmed = log.trimmingCharacters(in: .whitespacesAndNewlines)
        let lengthScore = min(max(Double(trimmed.count) / 800.0, 0.0), 1.0) // 0..1
        let qCount = trimmed.filter { $0 == "？" || $0 == "?" }.count
        let hasCompany = (context?.companyName.isEmpty == false)
        
        let companyLine: String = {
            guard let name = context?.companyName, !name.isEmpty else { return "" }
            return "・**\(name)** を前提とした回答の一貫性は概ね良好でした。"
        }()
        
        let pros: [String] = [
            "・声量と抑揚が自然で、聞き取りやすい話し方でした。",
            "・結論→理由→具体例の順で整理されており、要点が明確でした。",
            companyLine
        ].filter { !$0.isEmpty }
        
        let cons: [String] = [
            qCount < 1 ? "・逆質問がやや少なく、志望度の深掘りが伝わりにくい可能性があります。" : "",
            lengthScore < 0.35 ? "・回答が短めで、エピソードの具体性が不足していました。" : "",
            "・“なぜこの会社か”と“なぜこの職種か”を分けて語ると、説得力がさらに増します。"
        ].filter { !$0.isEmpty }
        
        let next: [String] = [
            "・**自己PR**は「強み→根拠→再現性→入社後活用」の順で30〜45秒に整える。",
            hasCompany ? "・**志望動機**は「事業理解→魅力→貢献仮説」を\(context!.companyName)の事例で具体化する。" : "・**志望動機**は「事業理解→魅力→貢献仮説」を企業の事例で具体化する。",
            "・**逆質問**を3つ用意（配属/期待役割、評価基準、入社後3ヶ月の目標など）。"
        ]
        
        let header = "総評：自然で前向きな印象です。回答の構造は概ね良く、具体例をもう一歩深めるとさらに強くなります。"
        let text = ([header, "", "良かった点:", pros.joined(separator: "\n"),
                     "", "改善ポイント:", cons.joined(separator: "\n"),
                     "", "次アクション:", next.joined(separator: "\n")]
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines))
        
        return InterviewFeedback(text: text)
    }
}
