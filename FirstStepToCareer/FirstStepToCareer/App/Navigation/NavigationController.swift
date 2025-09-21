//
//  NavigationController.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import SwiftUI

final class NavigationController: ObservableObject {
    // MARK: - Properties
    @Published var path: [Route] = []
}
