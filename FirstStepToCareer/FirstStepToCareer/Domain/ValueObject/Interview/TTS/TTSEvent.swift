//
//  TTSEvent.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

enum TTSEvent: Sendable {
    case started, finished, error(Error)
}
