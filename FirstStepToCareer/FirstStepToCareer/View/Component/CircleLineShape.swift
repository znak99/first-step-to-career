//
//  CircleLineShape.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import SwiftUI

struct CircleLineShape: Shape {
    // MARK: - Variables
    var startAngleAt: Double = 135
    var endAngleAt: Double = 45
    
    // MARK: - Functions
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(startAngleAt),
                    endAngle: .degrees(endAngleAt),
                    clockwise: false)
        
        return path
    }
}
