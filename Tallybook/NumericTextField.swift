//
//  NumericTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/12/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// SwiftUI compatibible wrapper of UITextField that adds custom functionality
struct NumericTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    let textField = UITextField()
    var placeholder: String?
    
    @Binding var text: String
    
    
    func makeUIView(context: UIViewRepresentableContext<NumericTextField>) -> UITextField {
                
        // Configure text field
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        (textField.delegate as! NumericUITextFieldDelegate).didEndEditing = { text in self.text = text }
        
        // Specific configuration for use in tally block. Probably not want I want
        textField.keyboardType = .numberPad
        textField.font = .systemRounded(style: .body, weight: .regular)
        textField.textAlignment = .right
        
        // Configure autolayout so that text field doesn't expand to fit content
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumericTextField>) {
        // Make sure that the text field adjusts for changes to the state that originate from other parts of the app
        uiView.text = text
    }
    
    func makeCoordinator() -> NumericUITextFieldDelegate {
        return NumericUITextFieldDelegate(text: $text)
    }
    
}

struct ContentView_TestNumericTextField : View {
    @State var numberOfBeans: String = "12"
    
    var body: some View {
        VStack {
            Text("Beans: " + (numberOfBeans))
            
            NumericTextField(placeholder: "Beans", text: $numberOfBeans)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        }
    }
}

struct NumericTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_TestNumericTextField()
    }
}
