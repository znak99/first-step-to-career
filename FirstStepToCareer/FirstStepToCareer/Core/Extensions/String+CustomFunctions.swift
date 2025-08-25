//
//  String+CustomFunctions.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

extension String {
    func truncated(_ length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return String(self[..<index]) + "..."
        } else {
            return self
        }
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func lastCharacters(_ length: Int) -> String {
        guard self.count > length else { return self }
        
        let startIndex = self.index(self.endIndex, offsetBy: -length)
        return "...\(String(self[startIndex...]))"
    }
}
