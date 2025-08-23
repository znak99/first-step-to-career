//
//  View+Frames.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftUI

extension View {
    func extraLargeFrame(alignment: Alignment) -> some View {
        self.frame(
            minWidth: ACLayout.Frame.extraLargeMin,
            idealWidth: ACLayout.Frame.extraLargeIdeal,
            maxWidth: ACLayout.Frame.extraLargeMax,
            minHeight: ACLayout.Frame.extraLargeMin,
            idealHeight: ACLayout.Frame.extraLargeIdeal,
            maxHeight: ACLayout.Frame.extraLargeMax,
            alignment: alignment
        )
    }
    
    func largeFrame(alignment: Alignment) -> some View {
        self.frame(
            minWidth: ACLayout.Frame.largeMin,
            idealWidth: ACLayout.Frame.largeIdeal,
            maxWidth: ACLayout.Frame.largeMax,
            minHeight: ACLayout.Frame.largeMin,
            idealHeight: ACLayout.Frame.largeIdeal,
            maxHeight: ACLayout.Frame.largeMax,
            alignment: alignment
        )
    }
    
    func mediumFrame(alignment: Alignment) -> some View {
        self.frame(
            minWidth: ACLayout.Frame.mediumMin,
            idealWidth: ACLayout.Frame.mediumIdeal,
            maxWidth: ACLayout.Frame.mediumMax,
            minHeight: ACLayout.Frame.mediumMin,
            idealHeight: ACLayout.Frame.mediumIdeal,
            maxHeight: ACLayout.Frame.mediumMax,
            alignment: alignment
        )
    }
    
    func smallFrame(alignment: Alignment) -> some View {
        self.frame(
            minWidth: ACLayout.Frame.smallMin,
            idealWidth: ACLayout.Frame.smallIdeal,
            maxWidth: ACLayout.Frame.smallMax,
            minHeight: ACLayout.Frame.smallMin,
            idealHeight: ACLayout.Frame.smallIdeal,
            maxHeight: ACLayout.Frame.smallMax,
            alignment: alignment
        )
    }
    
    func extraSmallFrame(alignment: Alignment) -> some View {
        self.frame(
            minWidth: ACLayout.Frame.extraSmallMin,
            idealWidth: ACLayout.Frame.extraSmallIdeal,
            maxWidth: ACLayout.Frame.extraSmallMax,
            minHeight: ACLayout.Frame.extraSmallMin,
            idealHeight: ACLayout.Frame.extraSmallIdeal,
            maxHeight: ACLayout.Frame.extraSmallMax,
            alignment: alignment
        )
    }
}
