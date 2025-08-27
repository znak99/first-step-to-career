//
//  TranscriptEvent.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

enum TranscriptEvent: Sendable {
    case partial(String)
    case final(String)
}
