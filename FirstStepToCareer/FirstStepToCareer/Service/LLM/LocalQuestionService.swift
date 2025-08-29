//
//  LocalQuestionService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation

// TODO: - API 요청 구현하기
actor LocalQuestionService: QuestionGenerating {
    
    var queue: [Question] = []
    init() {}
    
    func prefetch(_ n: Int, context: InterviewContext) async {
        guard n > 0 else { return }
        if queue.count >= n { return }
        let needed = n - queue.count
        let more = Self.makeBaselineQuestions(context: context, count: needed)
        queue.append(contentsOf: more)
    }
    
    func generateNextQuestion(context: InterviewContext) async throws -> Question {
        if let q = queue.first {
            queue.removeFirst()
            return q
        } else {
            // 큐가 비면 즉시 5개 정도 보충 후 1개 반환
            let batch = Self.makeBaselineQuestions(context: context, count: 5)
            queue.append(contentsOf: batch.dropFirst())
            return batch.first ?? Question("自己紹介をお願いします。")
        }
    }
    
    // MARK: - Templates
    
    /// コンテキストを使った定型質問を作る（会社名/職種/区分で分岐）
    static func makeBaselineQuestions(context: InterviewContext, count: Int) -> [Question] {
        let company = context.companyName.isEmpty ? "当社" : context.companyName
        let recruit = context.recruitType        // "新卒" / "中途" など
        let career  = context.careerType         // "iOSエンジニア" など
        
        var base: [String] = [
            "自己紹介をお願いします。",
            "自己PRをお願いします。",
            "\(company) を志望する理由は何ですか？",
            "\(career) を選んだ理由と、今後のキャリア目標を教えてください。",
            "学生時代（または直近）に力を入れたこと（ガクチカ/成果）は何ですか？",
            "あなたの強みと弱みをそれぞれ教えてください。",
            "困難を乗り越えた経験と、その際の工夫を教えてください。",
            "\(company) の事業やプロダクトについてどのように捉えていますか？",
            "入社後、最初の3ヶ月で何に取り組みますか？",
            "逆質問はありますか？"
        ]
        
        // recruit type에 따른 문장 미세 조정
        if recruit.contains("新卒") {
            base.insert("研究/ゼミ/インターンで取り組んだ内容を簡潔に説明してください。", at: 4)
        } else if recruit.contains("中途") {
            base.insert("直近のご経験で、最も成果を出したプロジェクトについて教えてください。", at: 4)
        }
        
        // 회사/직무 맥락 강조 질문 추가
        base.append("\(company) の\(career)として、どのように価値提供できますか？")
        
        // 요청된 개수만큼 슬라이스 (개수가 부족하면 순환)
        var out: [Question] = []
        if base.isEmpty { return [Question("自己紹介をお願いします。")] }
        
        var idx = 0
        while out.count < max(1, count) {
            out.append(Question(base[idx % base.count]))
            idx += 1
        }
        return out
    }
}
