//
//  SampleView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI
import Charts

struct SampleView: View {
    @State private var purpleChartPercent: Double = 0
    @State private var greenChartPercent: Double = 0
    
    @State private var purpleChartEnd: Double = 405
    @State private var greenChartEnd: Double = 136
    
    var body: some View {
        VStack {
            HStack {
                Text("Example")
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                Spacer()
            }
        }}
}

#Preview {
    SampleView()
}
