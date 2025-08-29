//
//  ServiceTestView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/29.
//

import SwiftUI

struct ServiceTestView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: VisionTestView()) {
                    Text("Vision Test")
                }
                
                NavigationLink(destination: ARKitTestView()) {
                    Text("ARKit Test")
                }
            }
        }
    }
}

#Preview {
    ServiceTestView()
}
