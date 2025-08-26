//
//  TTSService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/26.
//

import AVFoundation
import Combine

@MainActor
final class TTSService: NSObject, TTSServicing {
    private let synthesizer = AVSpeechSynthesizer()

    private let isSpeakingSubject = CurrentValueSubject<Bool, Never>(false)
    var isSpeakingPublisher: AnyPublisher<Bool, Never> {
        isSpeakingSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
            isSpeakingSubject.send(false)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate

        isSpeakingSubject.send(true)
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeakingSubject.send(false)
    }
}

extension TTSService: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didStart u: AVSpeechUtterance) {
        Task { @MainActor [weak self] in
            self?.isSpeakingSubject.send(true)
        }
    }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish u: AVSpeechUtterance) {
        Task { @MainActor [weak self] in
            self?.isSpeakingSubject.send(false)
        }
    }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didCancel u: AVSpeechUtterance) {
        Task { @MainActor [weak self] in
            self?.isSpeakingSubject.send(false)
        }
    }
}
