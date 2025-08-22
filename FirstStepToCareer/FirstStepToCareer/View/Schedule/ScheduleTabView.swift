//
//  ScheduleTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct ScheduleTabView: View {
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
                    icon: ScheduleTabIcon.header,
                    title: "Schedule",
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
    ScheduleTabView()
}
