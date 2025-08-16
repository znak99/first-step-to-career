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
            
            HStack {
                VStack {
                    ZStack {
                        CircleLineShape()
                            .stroke(Color.purple.opacity(0.3), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        CircleLineShape(endAngleAt: purpleChartEnd)
                            .stroke(Color.purple, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        Text("\(String(format: "%.1f", purpleChartPercent))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.purple)
                    }
                }
                .padding()
                
                VStack {
                    ZStack {
                        CircleLineShape()
                            .stroke(Color.green.opacity(0.3), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        CircleLineShape(endAngleAt: greenChartEnd)
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        Text("\(String(format: "%.1f", greenChartPercent))%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                }
                .padding()
            }
            .padding(.horizontal)
            
            Button(action: {
                withAnimation {
                    purpleChartPercent = (Double.random(in: 1..<100) * 10).rounded() / 10
                    greenChartPercent = (Double.random(in: 1..<100) * 10).rounded() / 10
                    purpleChartEnd = 135
                    greenChartEnd = 135
                    purpleChartEnd += 270 * (purpleChartPercent * 0.01)
                    greenChartEnd += 270 * (greenChartPercent * 0.01)
                }
            }) {
                Text("Random")
            }
            
            Spacer()
        }
        .padding([.top, .horizontal])
    }
}

#Preview {
    SampleView()
}
