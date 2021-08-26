//
//  CustomTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/2/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// SwiftUI compatibible wrapper of UITextField that adds custom functionality for usage in TallyBlock
struct NumericTallyTextField: UIViewRepresentable {

    // Subclass of UITextField that makes cursor slightly smaller so that it fits in TallyBlock without interfering with nearby sibling views
    class NumericUITextField: UITextField {
        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.size.height = 80
            rect = rect.offsetBy(dx: 0, dy: 20)
            return rect
        }
    }

    let textField = NumericTallyTextField.NumericUITextField()
    var placeholder: String?
    @Binding var text: String

    func makeUIView(context: UIViewRepresentableContext<NumericTallyTextField>) -> UITextField {

        // Specific configuration for use in tally block
        textField.keyboardType = .numberPad
        textField.font = .systemRounded(size: 99, weight: .regular)
        textField.placeholder = placeholder

        // When the user presses the done button, update the text binding, which sends the new text up the hierarchy
        // The coordinator is set in makeCoordinator() below, which uses a custom UITextField delegate defined in Helpers.swift that only accepts numeric 4 digit input
        textField.delegate = context.coordinator
        (textField.delegate as! NumericUITextFieldDelegate).didEndEditing = { text in self.text = text }

        // Add toolbar that shows done button above keyboard
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: textField, action: #selector(textField.resignFirstResponder))

        let buttonFont = UIFont.systemRounded(style: .body, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [.font: buttonFont,
                                                          .foregroundColor: UIColor.customAccent]

        doneButton.setTitleTextAttributes(attributes, for: .normal)
        doneButton.setTitleTextAttributes(attributes, for: .highlighted)

        toolbar.setItems([spacer, doneButton], animated: false)

        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar

        // Configure autolayout so that text field doesn't expand
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumericTallyTextField>) {
        // Make sure that the text field adjusts for changes to the state that originate from other parts of the app
        // This is done outside of the view update because setting the text during a view update can cause issues
        DispatchQueue.main.async {
            uiView.text = self.text
        }
    }

    func makeCoordinator() -> NumericUITextFieldDelegate {
        return NumericUITextFieldDelegate(text: $text)
    }

}

struct ContentView_TestNumericTallyTextField: View {
    @State var numberOfBeans: String = "12"

    var body: some View {
        VStack {
            Text("Beans: " + (numberOfBeans))

            NumericTallyTextField(placeholder: "Beans", text: $numberOfBeans)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        }
    }
}

struct NumericTallyTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_TestNumericTallyTextField()
    }
}
