//
//  CustomTabBarView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct CustomTabBarView: View {
    // MARK: - Variables
    @State private var currentTab: AppTab = .interview
    @State private var tabIconSize: CGFloat = 24
    
    // MARK: - UI
    var body: some View {
        ZStack {
            switch currentTab {
            case .interview:
                InterviewTabView()
            case .companyList:
                CompanyListTabView()
            case .schedule:
                ScheduleTabView()
            case .analysis:
                AnalysisTabView()
            case .settings:
                SettingsTabView()
            }
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    tabButton(.interview, label: AppTab.interview.label, icon: AppTab.interview.icon)
                    tabButton(.companyList, label: AppTab.companyList.label, icon: AppTab.companyList.icon)
                    tabButton(.schedule, label: AppTab.schedule.label, icon: AppTab.schedule.icon)
                    tabButton(.analysis, label: AppTab.analysis.label, icon: AppTab.analysis.icon)
                    tabButton(.settings, label: AppTab.settings.label, icon: AppTab.settings.icon)
                }
                .padding(.top, 8)
                .background(Color.appTabBarBackground)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    // MARK: - Functions
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
                .foregroundColor(currentTab == tab ? .appTabBarAccent : .appTabBarGray)
                .frame(maxWidth: .infinity)
            }
        )
    }
}

#Preview {
    CustomTabBarView()
}
