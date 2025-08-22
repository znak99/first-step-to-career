//
//  ManagementTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct ManagementTabView: View {
    // MARK: - Variables
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            Color.appBackground.ignoresSafeArea()
            
            // Main Contents
            VStack {
                // Header
                TabViewHeader(
                    icon: ManagementTabIcon.header,
                    title: "Management",
                    trailingActionIcon: nil,
                    trailingActionLabel: nil,
                    action: nil
                )
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: Route.self) { page in
                switch page {
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ManagementTabView()
}
