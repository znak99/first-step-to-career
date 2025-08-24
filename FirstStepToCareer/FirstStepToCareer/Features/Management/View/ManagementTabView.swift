//
//  ManagementTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct ManagementTabView: View {
    // MARK: - Variables
    @ObservedObject var vm: ManagementTabViewModel
    
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
                    title: "Management")
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ManagementTabView(vm: ManagementTabViewModel())
}
