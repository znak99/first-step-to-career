//
//  RootViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

@MainActor
final class RootViewModel: ObservableObject {
    // MARK: - Properties
    @Published var isAppReady: Bool = false
}
