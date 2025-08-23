//
//  String+CustomFunctions.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

extension String {
    // 문자열이 지정한 길이를 넘어가면 "..."으로 줄이는 함수
    // - Parameters:
    //   - length: 길이
    // - Returns: "..."로 줄어든 문자열
    // TODO: - 나중에 그냥 유틸로 빼도될거같기도함
    func truncated(_ length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index]) + "..."
        } else {
            return self
        }
    }
}
