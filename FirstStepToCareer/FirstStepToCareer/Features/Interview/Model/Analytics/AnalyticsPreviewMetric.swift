//
//  AnalyticsPreviewMetric.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/21.
//

import Foundation
import SwiftUI

struct AnalyticsPreviewMetric {
   let label: String
   let score: Double
   let start: Color
   let end: Color

   init(_ label: String, _ score: Double, _ color: Color) {
       self.label = label
       self.score = score
       self.start = color
       self.end = color
   }
}
