//
//  CustomAutofocusTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/5/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct CustomAutofocusTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    @Binding var text: String
    var isFirstResponder = false

    func makeUIView(context: UIViewRepresentableContext<CustomAutofocusTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        
        textField.textAlignment = .center
        textField.font = UIFont.systemRounded(style: .title1, weight: .semibold)
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomAutofocusTextField>) {
        uiView.text = text
        if uiView.window != nil, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
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
    
    func makeCoordinator() -> CustomAutofocusTextField.Coordinator {
        return Coordinator(text: $text)
    }
    
}

struct ContentView_TestCustomAutofocusTextField : View {
    @State var text: String = "12"
    
    var body: some View {
        CustomAutofocusTextField(text: $text)
    }
}

struct CustomAutofocusTextField_Previews: PreviewProvider {
    @State var text = "Help"
    static var previews: some View {
        ContentView_TestCustomAutofocusTextField()
    }
}

