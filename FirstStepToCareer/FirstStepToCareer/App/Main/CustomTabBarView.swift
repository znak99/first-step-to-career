//
//  CustomTabBarView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct AppTabBarView: View {
    // MARK: - Properties
    @State private var currentTab: AppTab = .interview
    @State private var tabIconSize: CGFloat = 24
    
    // MARK: - Body
    var body: some View {
        ZStack {
            switch currentTab {
            case .interview:
                InterviewTabView()
            case .schedule:
                ScheduleTabView()
            case .management:
                ManagementTabView()
            case .settings:
                SettingsTabView()
            }
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    tabButton(.interview, label: AppTab.interview.label, icon: AppTab.interview.icon)
                    tabButton(.schedule, label: AppTab.schedule.label, icon: AppTab.schedule.icon)
                    tabButton(.management, label: AppTab.management.label, icon: AppTab.management.icon)
                    tabButton(.settings, label: AppTab.settings.label, icon: AppTab.settings.icon)
                }
                .padding(.top, ACLayout.Padding.extraSmall)
                .background(ACColor.Brand.backgroundPrimary)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    // MARK: - Helpers
    private func tabButton(_ tab: AppTab, label: String, icon: String) -> some View {
        Button(
            action: {
                currentTab = tab
            },
            label: {
                VStack {
                    Image(systemName: icon)
                        .font(.system(size: tabIconSize))
                        .frame(width: tabIconSize, height: tabIconSize)
                    Text(label)
                        .font(.caption)
                }
                .padding(.horizontal)
                .foregroundColor(currentTab == tab ? .appPrimary : .appTabBarGray)
                .frame(maxWidth: .infinity)
            }
        )
    }
}

#Preview {
    AppTabBarView()
}
