//
//  STTService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/25.
//

import Foundation
import Speech
import AVFoundation
import Combine

@MainActor
final class STTService: STTStreaming {
    // MARK: Combine subjects
    private let transcriptSubject = PassthroughSubject<String, Never>()
    private let isRunningSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()

    var transcriptPublisher: AnyPublisher<String, Never> { transcriptSubject.eraseToAnyPublisher() }
    var isRunningPublisher: AnyPublisher<Bool, Never> { isRunningSubject.eraseToAnyPublisher() }
    var errorPublisher: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }

    // MARK: Internals
    private let audioEngine = AVAudioEngine()
    private let recognizer: SFSpeechRecognizer
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    init(locale: Locale = .init(identifier: "ja-JP")) {
        guard let r = SFSpeechRecognizer(locale: locale) else {
            fatalError("SFSpeechRecognizer init failed for locale: \(locale)")
        }
        self.recognizer = r
        self.recognizer.defaultTaskHint = .dictation // [ADDED] 안정성 힌트(선택)
    }

    func start() {
        guard !isRunningSubject.value else { return }
        isRunningSubject.send(true)

        do {
            let s = AVAudioSession.sharedInstance()
            // try s.setCategory(.record, mode: .measurement, options: .duckOthers)
            // [UPDATED] 카테고리는 상위(AudioService)에서 .playAndRecord로 관리.
            // 여기서는 활성화만 하여 카테고리 충돌/인터럽션을 줄임.
            try s.setActive(true, options: .notifyOthersOnDeactivation)

            // 요청
            let req = SFSpeechAudioBufferRecognitionRequest()
            req.shouldReportPartialResults = true
            self.request = req

            // 오디오 탭
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
                    self.transcriptSubject.send(result.bestTranscription.formattedString)
                    if result.isFinal {
                        // self.stop()  // ← 취소 로그를 유발할 수 있음
                        self.finishAndTearDown() // [UPDATED] 정상 종료 경로로 통일
                    }
                } else if let error {
                    self.errorSubject.send(error)
                    // [UPDATED] 에러 시에도 정상 정리
                    self.finishAndTearDown()
                }
            }

        } catch {
            errorSubject.send(error)
            finishAndTearDown() // [UPDATED] 실패 시 정리
        }
    }

    func stop() {
        guard isRunningSubject.value else { return }
        isRunningSubject.send(false)
        // task?.cancel()
        // [UPDATED] 취소 대신 정상 종료 시퀀스로 통일
        finishAndTearDown()
    }

    // MARK: - Normal finish teardown
    private func finishAndTearDown() {
        // [ADDED] 정상 종료 순서: endAudio → finish → tap 제거/엔진 stop → (조금 뒤) setActive(false)
        request?.endAudio()
        task?.finish()

        audioEngine.inputNode.removeTap(onBus: 0)
        if audioEngine.isRunning {
            audioEngine.stop()
        }

        // [ADDED] 참조 해제는 너무 빨리 하지 말고, 여기서 일괄
        let _ = task
        let _ = request
        task = nil
        request = nil

        // [ADDED] 세션 비활성화는 약간 지연 → cancel 로그/레이스 감소
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            do {
                try AVAudioSession.sharedInstance().setActive(false,
                                                             options: [.notifyOthersOnDeactivation])
            } catch {
                self.errorSubject.send(error)
            }
            // [UPDATED] Publisher 상태 최종 반영
            self.isRunningSubject.send(false)
        }
    }
}
