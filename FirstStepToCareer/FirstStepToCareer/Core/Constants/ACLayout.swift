//
//  ACLayout.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

enum ACLayout {
    // MARK: - Padding
    enum Padding {
        static let extraLarge: CGFloat = 20
        static let large: CGFloat = 16
        static let medium: CGFloat = 12
        static let small: CGFloat = 8
        static let extraSmall: CGFloat = 4
        static let safeArea: CGFloat = 16
    }

    // MARK: - Radius
    enum Radius {
        static let extraLarge: CGFloat = 20
        static let large: CGFloat = 16
        static let medium: CGFloat = 12
        static let small: CGFloat = 8
        static let extraSmall: CGFloat = 4
    }
    
    // MARK: - Frame
    enum Frame {
        static let extraLargeMin: CGFloat = 68
        static let extraLargeIdeal: CGFloat = 80
        static let extraLargeMax: CGFloat = 92
        
        static let largeMin: CGFloat = 40
        static let largeIdeal: CGFloat = 48
        static let largeMax: CGFloat = 56
        
        static let mediumMin: CGFloat = 28
        static let mediumIdeal: CGFloat = 32
        static let mediumMax: CGFloat = 36
        
        static let smallMin: CGFloat = 20
        static let smallIdeal: CGFloat = 24
        static let smallMax: CGFloat = 28
        
        static let extraSmallMin: CGFloat = 16
        static let extraSmallIdeal: CGFloat = 20
        static let extraSmallMax: CGFloat = 24
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let section: CGFloat = 16
        static let large: CGFloat = 12
        static let medium: CGFloat = 8
        static let small: CGFloat = 4
    }
}
