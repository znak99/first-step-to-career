//
//  STTServicing.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/25.
//

import Foundation

protocol STTServicing: AnyObject {
    var onUpdate: (String) -> Void { get set }
    var onError: (Error) -> Void { get set }
    var onFinished: () -> Void { get set }

    func start()
    func stop()
}
