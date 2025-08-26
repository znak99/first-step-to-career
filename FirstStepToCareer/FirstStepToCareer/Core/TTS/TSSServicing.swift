//
//  TSSServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/26.
//

import Foundation
import Combine

@MainActor
protocol TTSServicing: AnyObject {
    var isSpeakingPublisher: AnyPublisher<Bool, Never> { get }
    func speak(_ text: String)
    func stop()
}

