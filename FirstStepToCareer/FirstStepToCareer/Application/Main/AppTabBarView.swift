//
//  AppTabBarView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

struct AppTabBarView: View {
    // MARK: - Properties
    @StateObject private var vm: AppTabBarViewModel = .init()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            switch vm.currentTab {
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
                    tabButton(.interview)
                    tabButton(.schedule)
                    tabButton(.management)
                    tabButton(.settings)
                }
                .padding(.top, ACLayout.Padding.small)
                .background(ACColor.TabBar.background)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    // MARK: - Helpers
    private func tabButton(_ tab: AppTab) -> some View {
        Button(
            action: {
                vm.tabTapped(tab: tab)
            },
            label: {
                VStack(spacing: 0) {
                    Image(systemName: tab.icon)
                        .resizable()
                        .scaledToFit()
                        .extraSmallFrame(alignment: .center)
                    Text(tab.label)
                        .font(.custom(ACFont.Weight.regular, size: ACFont.Size.extraSmall, relativeTo: .caption))
                }
                .padding(.horizontal, ACLayout.Padding.small)
                .foregroundColor(vm.currentTab == tab ?
                                 ACColor.TabBar.active : ACColor.TabBar.inactive)
                .frame(maxWidth: .infinity)
            }
        )
    }
}

#Preview {
    AppTabBarView()
}
