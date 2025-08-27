//
//  AppTextField.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct AppTextField: View {
    // MARK: - Properties
    let placeholder: String
    @Binding var text: String
    var focus: FocusState<FocusTarget?>.Binding
    let focusTarget: FocusTarget
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(ACColor.Font.gray)
                    .offset(y: 0)
            }
            TextField("", text: $text)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.default)
                .focused(focus, equals: focusTarget)
                .onChange(of: text) { _, newValue in
                    if newValue.first == " " {
                        text = String(newValue.drop(while: { $0 == " " }))
                    }
                }
        }
        .font(.custom(ACFont.Weight.regular, size: ACFont.Size.small, relativeTo: .body))
        .padding(ACLayout.Padding.small)
        .background(
            RoundedRectangle(cornerRadius: ACLayout.Radius.small)
                .fill(ACColor.Brand.backgroundPrimary)
        )
    }
}

#Preview {
    PreviewHost()
}

private struct PreviewHost: View {
    @State private var text: String = ""
    @FocusState private var focus: FocusTarget?

    var body: some View {
        AppTextField(
            placeholder: "会社名",
            text: $text,
            focus: $focus,
            focusTarget: .companyName
        )
        .padding()
        .onAppear { focus = .companyName }
    }
}
