//
//  AppTabBarViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

@MainActor
final class AppTabBarViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentTab: AppTab = .interview
    
    // MARK: - Actions
    func tabTapped(tab: AppTab) {
        currentTab = tab
    }
}
