//
//  ScheduleTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct ScheduleTabView: View {
    // MARK: - Variables
    @ObservedObject var vm: ScheduleTabViewModel
    
    // MARK: - UI
    var body: some View {
        ZStack {
            // Background
            ACColor.Brand.backgroundPrimary
            
            // Main Contents
            VStack {
                // Header
                TabViewHeader(
                    icon: ACIcon.Vector.calendarBlack,
                    title: "Schedule"
                )                
                
                Spacer()
            }
            .padding(.horizontal, ACLayout.Padding.safeArea)
        }
    }
}

#Preview {
    ScheduleTabView(vm: ScheduleTabViewModel())
}
