//
//  NavigationController.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/16.
//

import Foundation

// 네비게이션을 제어하기 위한 컨트롤러(pagePath로 네비게이션 스택 확인)
class NavigationController: ObservableObject {
    @Published var pagePath: [AppPage] = []
}
