//
//  SettingsTabView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import SwiftUI

struct SettingsTabView: View {
    // MARK: - Variables
    @ObservedObject var vm: SettingsTabViewModel
    
    // MARK: - UI
    var body: some View {
        Text("Settings")
    }
}

#Preview {
    SettingsTabView(vm: SettingsTabViewModel())
}
