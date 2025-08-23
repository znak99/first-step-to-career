//
//  InterviewPrepareViewModel.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/22.
//

import Foundation

@MainActor
final class InterviewPrepareViewModel: ObservableObject {
    let permissionManager = PermissionManager()
    @Published var interviewInfo: InterviewInfo = .init()
    @Published var sectionHeaderLottie: String?
    @Published var isPermissionsReady: Bool = false
    
    func checkPermissions() {
        permissionManager.requestCamera { [weak self] granted in
            guard let self else { return }
            self.isPermissionsReady = granted
            
        }
        
        permissionManager.requestMicrophone { [weak self] granted in
            guard let self else { return }
            self.isPermissionsReady = granted
        }
    }
}
