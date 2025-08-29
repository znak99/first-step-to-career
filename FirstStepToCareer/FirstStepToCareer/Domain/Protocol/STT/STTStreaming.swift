//
//  STTStreaming.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation

@MainActor
protocol STTStreaming: Sendable {
    func start(locale: Locale) -> AsyncStream<TranscriptEvent>   // partial/final 이벤트 스트림
    func stop()
    func pause()
    func resume()
}
