//
//  InterviewViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import Foundation
import SwiftUI
import AVFoundation
import CoreMedia

@MainActor
final class InterviewViewModel: ObservableObject {
    // MARK: - Properties
    @Published var isShowDismissModal: Bool = false
    
    // MARK: - Actions
    func exitButtonTapped(completion: @escaping () -> Void) {
        completion()
    }
}
