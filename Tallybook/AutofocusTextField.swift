//
//  CustomAutofocusTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/5/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct AutofocusTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    @Binding var text: String
    var didBecomeFirstResponder = false


    func makeUIView(context: UIViewRepresentableContext<AutofocusTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        
        textField.textAlignment = .center
        textField.font = UIFont.systemRounded(style: .title1, weight: .semibold)
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<AutofocusTextField>) {
        uiView.text = text
        
        // Make text field first responder whenever view is shown
        if uiView.window != nil && !(uiView.delegate as! AutofocusTextField.Coordinator).didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            (uiView.delegate as! AutofocusTextField.Coordinator).didBecomeFirstResponder = true
        }
    }
    
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        var didBecomeFirstResponder = false

                
        init(text: Binding<String>) {
            _text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> AutofocusTextField.Coordinator {
        return Coordinator(text: $text)
    }
    
}

struct ContentView_TestAutofocusTextField : View {
    @State var text: String = "12"
    
    var body: some View {
        AutofocusTextField(text: $text)
    }
}

struct AutofocusTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_TestAutofocusTextField()
    }
}

