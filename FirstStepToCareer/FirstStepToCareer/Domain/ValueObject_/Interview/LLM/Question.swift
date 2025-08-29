//
//  Question.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/27.
//

import Foundation

struct Question: Sendable, Hashable {
    var text: String
    var keypoints: [String]
    init(_ text: String, keypoints: [String] = []) { self.text = text; self.keypoints = keypoints }
}
