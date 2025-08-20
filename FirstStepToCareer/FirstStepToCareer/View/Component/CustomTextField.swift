//
//  CustomTextField.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct CustomTextField: View {
    // MARK: - Variables
    let placeholder: String
    @Binding var text: String
    var focus: FocusState<FocusTarget?>.Binding
    let focusTarget: FocusTarget
    
    // MARK: - UI
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .offset(y: 0)
            }
            TextField("", text: $text)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.default)
                .focused(focus, equals: focusTarget)
        }
        .font(.custom(Font.appRegular, size: 16, relativeTo: .body))
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: AppConstant.Radius.field)
                .fill(Color.appBackground)
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
        CustomTextField(
            placeholder: "会社名",
            text: $text,
            focus: $focus,
            focusTarget: .companyName
        )
        .padding()
        .onAppear { focus = .companyName }
    }
}
