//
//  STTService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/25.
//

// Path: Services/STT/STTService.swift
import Foundation
import Speech
import AVFoundation

@MainActor
final class STTService: NSObject, STTStreaming {

    // MARK: - State
    private var recognizer: SFSpeechRecognizer?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()

    private var continuation: AsyncStream<TranscriptEvent>.Continuation?

    // MARK: - Start (AsyncStream)
    func start(locale: Locale) -> AsyncStream<TranscriptEvent> {
        recognizer = SFSpeechRecognizer(locale: locale)

        // 기존 세션 정리(재시작 대비)
        stop()

        return AsyncStream { [weak self] cont in
            guard let self else { return }
            self.continuation = cont

            // 권한 확인(사전 요청은 PermissionService에서)
            guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
                cont.finish(); return
            }

            // 요청 준비
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            self.recognitionRequest = request

            // 오디오 엔진 탭 설치 (세션 카테고리는 AudioSessionService가 담당)
            let input = self.audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                request.append(buffer)
            }

            self.audioEngine.prepare()
            do { try self.audioEngine.start() } catch {
                cont.finish(); return
            }

            // 인식 태스크
            self.recognitionTask = self.recognizer?.recognitionTask(with: request) { [weak self] result, error in
                guard let self, let cont = self.continuation else { return }
                if let result {
                    let text = result.bestTranscription.formattedString
                    if result.isFinal {
                        cont.yield(.final(text))
                    } else {
                        cont.yield(.partial(text))
                    }
                }
                if error != nil {
                    cont.finish()
                }
            }
        }
    }

    // MARK: - Stop / Pause / Resume
    func stop() {
        // 순서 중요: tap 제거 → 엔진 정지 → 요청/태스크 종료
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        if audioEngine.isRunning { audioEngine.stop() }

        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        recognitionTask = nil
        recognitionRequest = nil
        recognizer = nil

        continuation?.finish()
        continuation = nil
    }

    func pause() {
        // 인식 세션은 유지하고 입력만 중단
        if audioEngine.isRunning { audioEngine.pause() }
    }

    func resume() {
        // 엔진 재가동(실패해도 앱 크래시 없이 무시)
        try? audioEngine.start()
    }
}
