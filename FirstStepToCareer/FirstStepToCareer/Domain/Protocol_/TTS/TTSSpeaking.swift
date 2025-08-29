//
//  TTSSpeaking.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/28.
//

import Foundation

@MainActor
protocol TTSSpeaking: Sendable {
    func speak(text: String) -> AsyncStream<TTSEvent>           // started/finished/error 스트림
    func stop()
}
