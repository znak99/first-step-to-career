//
//  ACFont.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/23.
//

import SwiftUI

enum ACFont {
    // MARK: - Weight
    enum Weight {
        static let black: String = "NotoSansJP-Black"
        static let extraBold: String = "NotoSansJP-ExtraBold"
        static let bold: String = "NotoSansJP-Bold"
        static let semiBold: String = "NotoSansJP-SemiBold"
        static let medium: String = "NotoSansJP-Medium"
        static let regular: String = "NotoSansJP-Regular"
        static let light: String = "NotoSansJP-Light"
        static let extraLight: String = "NotoSansJP-ExtraLight"
        static let thin: String = "NotoSansJP-Thin"
    }
    
    // MARK: - Size
    enum Size {
        static let extraLarge: CGFloat = 28
        static let large: CGFloat = 24
        static let medium: CGFloat = 20
        static let small: CGFloat = 16
        static let extraSmall: CGFloat = 12
    }
}
