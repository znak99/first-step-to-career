//
//  STTServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

import AVFoundation

// MARK: - 프로토콜(최소 기능)
@MainActor
public protocol STTServicing: AnyObject {
    var transcripts: AsyncStream<STTTranscript> { get }
    var events: AsyncStream<STTEvent> { get }

    func prepare()
    func start() async
    func stop()
    func pause()
    func resume()
    func shutdown() async
}
