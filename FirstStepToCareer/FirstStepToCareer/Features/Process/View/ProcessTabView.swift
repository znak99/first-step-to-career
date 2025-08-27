//
//  ProcessTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct ProcessTabView: View {
    // MARK: - Variables
    @ObservedObject var vm: ProcessTabViewModel
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            ACColor.Brand.backgroundPrimary
            
            // Main Contents
            VStack {
                // Header
                TabViewHeader(
                    icon: ACIcon.Vector.blackboardBlack,
                    title: "Process")
                
                Spacer()
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
    }
}

#Preview {
    ProcessTabView(vm: ProcessTabViewModel())
}
