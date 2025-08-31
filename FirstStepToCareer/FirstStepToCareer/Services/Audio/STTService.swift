//
//  STTService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation
import Speech
import Accelerate

// MARK: - 구현체
@MainActor
public final class STTService: NSObject, STTServicing {

    // 의존성
    private let audio: AudioSessionService

    // Speech
    private var recognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    // Audio
    private let engine = AVAudioEngine()
    private var inputFormat: AVAudioFormat?

    // 스트림
    private let transcriptStream: AsyncStream<STTTranscript>
    private var transcriptCont: AsyncStream<STTTranscript>.Continuation?

    private let eventStream: AsyncStream<STTEvent>
    private var eventCont: AsyncStream<STTEvent>.Continuation?

    // === 무음(dBFS) 기반 판정 ===
    // 임계값(기본 -45dBFS 근처: 말할 때 보통 -35~-10dBFS 정도, 환경 따라 조정)
    private let silenceThresholdDB: Float
    // 무음 지속 시간(초)
    private let silenceSeconds: TimeInterval
    // 최근 “소음 이상”(=말소리로 간주) 감지 시각
    private var lastLoudTime: TimeInterval = 0
    // 주기적 체크 타이머(0.2초 간격)
    private var silenceCheckTimer: DispatchSourceTimer?

    // 상태
    private var isPaused = false

    public var transcripts: AsyncStream<STTTranscript> { transcriptStream }
    public var events: AsyncStream<STTEvent> { eventStream }

    // MARK: - Init
    public init(audio: AudioSessionService,
                silenceThresholdDB: Float = -45.0,
                silenceSeconds: TimeInterval = 3.0) {
        self.audio = audio
        self.silenceThresholdDB = silenceThresholdDB
        self.silenceSeconds = silenceSeconds

        var tCont: AsyncStream<STTTranscript>.Continuation?
        self.transcriptStream = AsyncStream<STTTranscript> { tCont = $0 }
        self.transcriptCont = tCont

        var eCont: AsyncStream<STTEvent>.Continuation?
        self.eventStream = AsyncStream<STTEvent> { eCont = $0 }
        self.eventCont = eCont

        super.init()
    }

    // MARK: - STTServicing
    public func prepare() {
        if recognizer == nil {
            recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
        }
        inputFormat = engine.inputNode.outputFormat(forBus: 0)
        engine.prepare()
    }

    public func start() async {
        _ = await audio.acquire(.stt)

        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))

        cleanupRecognition(keepSession: true)

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        request = req

        attachTapIfNeeded()

        do { try engine.start() }
        catch { eventCont?.yield(.didFail); return }

        guard let recognizer, let request else {
            eventCont?.yield(.didFail); return
        }

        eventCont?.yield(.didStart)
        // “시작 시각”을 큰 소리로 간주해 타임아웃 즉시 발생 방지
        lastLoudTime = CFAbsoluteTimeGetCurrent()

        // 인식 작업
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            Task { @MainActor in
                if let result {
                    let text = result.bestTranscription.formattedString
                    if !text.isEmpty {
                        // partial/final 구분해서 전달
                        self.transcriptCont?.yield(.init(text: text, isFinal: result.isFinal))
                        // 텍스트가 갱신되면 “소리 있었다”고 판단해 타임스탬프 갱신
                        self.lastLoudTime = CFAbsoluteTimeGetCurrent()
                    }
                    if result.isFinal {
                        self.finishDueTo(.didFinish)
                    }
                } else if error != nil {
                    self.finishDueTo(.didFail)
                }
            }
        }

        startSilenceCheckTimer()
    }

    public func stop() {
        removeTapIfNeeded()
        engine.stop()
        request?.endAudio()
        finishDueTo(.didFinish)
    }

    public func pause() {
        isPaused = true
        removeTapIfNeeded()
    }

    public func resume() {
        guard isPaused else { return }
        isPaused = false
        attachTapIfNeeded()
        // 재개 직후 즉시 타임아웃 방지
        lastLoudTime = CFAbsoluteTimeGetCurrent()
    }

    public func shutdown() async {
        stop()
        cleanupRecognition(keepSession: false)
        await audio.release(.stt)
    }

    // MARK: - Audio Tap

    private func attachTapIfNeeded() {
        removeTapIfNeeded()

        let format = inputFormat ?? engine.inputNode.outputFormat(forBus: 0)
        engine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self, let request = self.request, !self.isPaused else { return }

            // 1) 인식으로 전달
            request.append(buffer)

            // 2) dBFS 계산 → 임계값 초과 시 “소리 감지”
            if self.bufferIsLoud(buffer, thresholdDB: self.silenceThresholdDB) {
                self.lastLoudTime = CFAbsoluteTimeGetCurrent()
            }
        }
    }

    private func removeTapIfNeeded() {
        engine.inputNode.removeTap(onBus: 0)
    }

    // MARK: - dBFS 기반 무음 체크

    private func startSilenceCheckTimer() {
        silenceCheckTimer?.cancel()
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + 0.2, repeating: 0.2)
        timer.setEventHandler { [weak self] in
            guard let self else { return }
            let now = CFAbsoluteTimeGetCurrent()
            if now - self.lastLoudTime >= self.silenceSeconds {
                self.finishDueTo(.didSilenceTimeout)
            }
        }
        silenceCheckTimer = timer
        timer.resume()
    }

    // float PCM에서 RMS→dBFS 계산(모노/스테레오 모두 처리)
    private func bufferIsLoud(_ buffer: AVAudioPCMBuffer, thresholdDB: Float) -> Bool {
        guard let ch = buffer.floatChannelData else { return false }
        let frameCount = Int(buffer.frameLength)
        if frameCount == 0 { return false }

        var accum: Float = 0
        let channels = Int(buffer.format.channelCount)
        for c in 0..<channels {
            let samples = ch[c]
            var sum: Float = 0
            vDSP_measqv(samples, 1, &sum, vDSP_Length(frameCount)) // mean of squares
            accum += sum
        }
        let meanSquare = accum / Float(channels)
        // sqrt(meanSquare) = RMS, dBFS = 20*log10(RMS), 0 보정
        if meanSquare <= 0 { return false }
        let rms = sqrtf(meanSquare)
        let db = 20 * log10f(rms)
        return db > thresholdDB
    }

    // MARK: - 마무리/정리

    private func finishDueTo(_ reason: STTEvent) {
        silenceCheckTimer?.cancel()
        silenceCheckTimer = nil

        task?.cancel()
        task = nil

        request?.endAudio()

        switch reason {
        case .didFinish:          eventCont?.yield(.didFinish)
        case .didSilenceTimeout:  eventCont?.yield(.didSilenceTimeout)
        case .didFail:            eventCont?.yield(.didFail)
        case .didCancel:          eventCont?.yield(.didCancel)
        case .didStart:           break
        }
    }

    private func cleanupRecognition(keepSession: Bool) {
        silenceCheckTimer?.cancel()
        silenceCheckTimer = nil

        task?.cancel(); task = nil
        if engine.isRunning { removeTapIfNeeded(); engine.stop() }

        if keepSession {
            request = nil
        } else {
            request = nil
            recognizer = nil
        }
    }
}
