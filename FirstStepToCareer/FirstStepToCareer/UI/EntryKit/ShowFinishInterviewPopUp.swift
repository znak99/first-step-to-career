//
//  ShowFinishInterviewPopUp.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/24.
//

import SwiftEntryKit
import UIKit
import SwiftUI

extension EntryKitPresenter {
    func showConfirmExit(onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        // MARK: - Constants
        let displayDuration: CGFloat = .infinity
        let animScaleFrom: CGFloat = 0.9
        let animScaleTo: CGFloat = 1.0
        let animFadeFrom: CGFloat = 0.0
        let animFadeTo: CGFloat = 1.0
        let animDuration: CGFloat = 0.3
        
        // MARK: - Attributes
        var att: EKAttributes = .init()
        att.position = .center
        att.positionConstraints.size = .init(
            width: .ratio(value: 0.7),
            height: .intrinsic
        )
        att.displayDuration = displayDuration
        att.entryBackground = .color(color: .init(.init(ACColor.Brand.backgroundPrimary)))
        att.screenBackground = .color(color: .init(.init(ACColor.Font.black.opacity(0.3))))
        att.roundCorners = .all(radius: ACLayout.Radius.large)
        att.entryInteraction = .absorbTouches
        att.screenInteraction = .dismiss
        att.scroll = .disabled
        att.entranceAnimation = .init(
            scale: .init(from: animScaleFrom, to: animScaleTo, duration: animDuration),
            fade: .init(from: animFadeFrom, to: animFadeTo, duration: animDuration)
        )
        att.exitAnimation = .init(
            scale: .init(from: animScaleTo, to: animScaleFrom, duration: animDuration),
            fade: .init(from: animFadeTo, to: animFadeFrom, duration: animDuration)
        )

        // MARK: - Content
        let title = EKProperty.LabelContent(
            text: "模擬面接を終了しますか？",
            style: .init(
                font: .boldSystemFont(ofSize: ACFont.Size.small),
                color: .init(.init(ACColor.Font.black)))
        )
        let desc = EKProperty.LabelContent(
            text: "今までの模擬面接は保存されません",
            style: .init(
                font: .systemFont(ofSize: ACFont.Size.extraSmall),
                color: .init(.init(ACColor.Font.black)))
        )
        let icon = EKProperty.ImageContent(
            image: UIImage(named: ACIcon.Image.warningCircleYellow3D)!,
            size: .init(width: ACLayout.Frame.largeIdeal,
                        height: ACLayout.Frame.largeIdeal),
        )
        let simple = EKSimpleMessage(image: icon, title: title, description: desc)

        let ok = EKProperty.ButtonContent(
            label: .init(
                text: "終了",
                style: .init(
                    font: .boldSystemFont(ofSize: ACFont.Size.small),
                    color: .init(.init(ACColor.Status.error)))
            ),
            backgroundColor: .init(.init(ACColor.Brand.backgroundPrimary)),
            highlightedBackgroundColor: .init(.init(ACColor.Brand.backgroundPrimary)).with(alpha: 0.9),
            action: {
                onConfirm()
                SwiftEntryKit.dismiss()
            }
        )

        let cancel = EKProperty.ButtonContent(
            label: .init(
                text: "キャンセル",
                style: .init(
                    font: .boldSystemFont(ofSize: ACFont.Size.small),
                    color: .init(.init(ACColor.Font.black)))
            ),
            backgroundColor: .init(.init(ACColor.Brand.backgroundPrimary)),
            highlightedBackgroundColor: .init(.init(ACColor.Brand.backgroundPrimary)).with(alpha: 0.9),
            action: {
                onCancel()
                SwiftEntryKit.dismiss()
            }
        )

        let buttons = EKProperty.ButtonBarContent(
            with: ok, cancel,
            separatorColor: .init(.separator),
            expandAnimatedly: true
        )
        let alert = EKAlertMessage(simpleMessage: simple, buttonBarContent: buttons)
        let view = EKAlertMessageView(with: alert)
        
        // MARK: - Present
        SwiftEntryKit.display(entry: view, using: att)
    }
}
