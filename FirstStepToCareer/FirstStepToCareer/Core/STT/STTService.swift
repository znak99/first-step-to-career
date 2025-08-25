//
//  STTService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/25.
//

import Foundation
import Speech
import AVFoundation
import AVFAudio

final class STTService: STTServicing {

    // MARK: - Callbacks
    var onUpdate: (String) -> Void = { _ in }
    var onError: (Error) -> Void = { _ in }
    var onFinished: () -> Void = {}

    // MARK: - Internals
    private let audioEngine = AVAudioEngine()
    private let recognizer: SFSpeechRecognizer
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var isRunning = false

    init(locale: Locale = Locale(identifier: "ja-JP")) {
        self.recognizer = SFSpeechRecognizer(locale: locale)!
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        do {
            // 오디오 세션
            let s = AVAudioSession.sharedInstance()
            try s.setCategory(.record, mode: .measurement, options: .duckOthers)
            try s.setActive(true, options: .notifyOthersOnDeactivation)

            // 새 요청(재시작 대비)
            let req = SFSpeechAudioBufferRecognitionRequest()
            req.shouldReportPartialResults = true
            self.request = req

            // 입력 탭
            let input = audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)
            input.removeTap(onBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buf, _ in
                self?.request?.append(buf)
            }

            audioEngine.prepare()
            try audioEngine.start()

            // 인식 태스크
            task = recognizer.recognitionTask(with: req) { [weak self] result, error in
                guard let self else { return }
                if let result {
                    self.onUpdate(result.bestTranscription.formattedString)
                    // 계속 듣고 싶으면 아래 자동 stop 제거
                    if result.isFinal {
                        self.stop()
                    }
                } else if let error {
                    self.onError(error)
                    self.stop()
                }
            }
        } catch {
            onError(error)
            stop()
        }
    }

    func stop() {
        guard isRunning else { return }
        isRunning = false

        task?.cancel()
        task = nil

        request?.endAudio()
        request = nil

        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            onError(error)
        }

        onFinished()
    }
}
