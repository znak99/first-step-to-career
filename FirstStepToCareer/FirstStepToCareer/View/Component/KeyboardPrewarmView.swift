//
//  KeyboardPrewarmView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/17.
//

import Foundation
import UIKit
import SwiftUI

struct KeyboardPrewarmView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            tf.becomeFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                tf.resignFirstResponder()
            }
        }
        
        return tf
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {}
}
