//
//  AudioService.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/26.
//

import AVFAudio

@MainActor
final class AudioService {
    private let session = AVAudioSession.sharedInstance()
    
    func setCategoryForInterview() throws {
        try session.setCategory(.playAndRecord,
                                mode: .default,
                                options: [.defaultToSpeaker, .duckOthers, .allowBluetooth])
    }
    
    func activateSession(_ active: Bool) throws {
        try session.setActive(active, options: active ? [] : [.notifyOthersOnDeactivation])
    }
}
