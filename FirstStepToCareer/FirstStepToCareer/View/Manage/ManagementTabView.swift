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
                    icon: AppConstants.managementTabHeaderIcon,
                    title: "Management",
                    caption: "進捗・締切・連絡履歴を一元化すれば、\n抜け漏れ防止＆次の一手が速く決められます！"
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
