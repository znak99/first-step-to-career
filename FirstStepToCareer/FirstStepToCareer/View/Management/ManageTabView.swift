//
//  ManageTabView.swift
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
                    icon: AppConstants.scheduleTabHeaderIcon,
                    title: "Management",
                    caption: "就活はスケジュール管理が大事！\n締切守れば準備がはかどって、余裕もできます！"
                )
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationDestination(for: AppPage.self) { page in
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
