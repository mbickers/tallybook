//
//  CustomTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/2/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

class CustomNumericUITextField: UITextField, UITextFieldDelegate {
    
    // Have to resize cursor because the vertical padding is negative within TallyBlock
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.height = 80
        rect = rect.offsetBy(dx: 0, dy: 20)
        return rect
    }
    

    // Implementation of UITextFieldDelegate
    
    var didEndEditing: ((String?)->Void)?
    
    // Need to implement this in order to resign input when return key is pressed
    // This implementaiton doesn't effect the usage of the done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Make sure input is all digits and 4 characters or less
        let digits = CharacterSet.decimalDigits
        let newText = ((text ?? "") as NSString).replacingCharacters(in: range, with: string)
        return digits.isSuperset(of: CharacterSet(charactersIn: string)) && newText.count <= 4
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(text)
    }
}

// SwiftUI compatibible wrapper of CustomUITextField that adds custom functionality
struct TallyBlockTextField: UIViewRepresentable {
    
    let textField = CustomNumericUITextField()
    var placeholder: String?
    
    @Binding var text: String?
    
    
    func makeUIView(context: UIViewRepresentableContext<TallyBlockTextField>) -> UITextField {
        
        // Configure text field

        textField.delegate = textField
        textField.placeholder = placeholder
        textField.didEndEditing = { text in self.text = text }
        
        // Specific configuration for use in tally block. Probably not want I want
        textField.keyboardType = .numberPad
        textField.font = .systemRounded(size: 99, weight: .regular)
        
        
        // Add toolbar that shows done button above keyboard
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: textField, action: #selector(textField.resignFirstResponder))
        
        let buttonFont = UIFont.systemRounded(style: .body, weight: .regular)
        let attributes: [NSAttributedString.Key : Any] = [.font : buttonFont,
                                                          .foregroundColor : UIColor.customAccent]
        
        doneButton.setTitleTextAttributes(attributes, for: .normal)
        doneButton.setTitleTextAttributes(attributes, for: .highlighted)
        
        toolbar.setItems([spacer, doneButton], animated: false)
        
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        
        
        // Configure autolayout so that text field doesn't expand to fit content
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TallyBlockTextField>) {
        // Make sure that the text field adjusts for changes to the state that originate from other parts of the app
        uiView.text = text
    }
    
}



struct ContentView_TestCustomNumericTextField : View {
    @State var numberOfBeans: String? = "12"
    
    var body: some View {
        VStack {
            Text("Beans: " + (numberOfBeans ?? "0"))
            
            TallyBlockTextField(placeholder: "Beans", text: $numberOfBeans)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        }
    }
}

struct CustomNumericTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_TestCustomNumericTextField()
    }
}
