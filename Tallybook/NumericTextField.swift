//
//  NumericTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/12/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// SwiftUI compatibible wrapper of UITextField that only allows numeric input
struct NumericTextField: UIViewRepresentable {
  typealias UIViewType = UITextField

  let textField = UITextField()
  var placeholder: String?
  @Binding var text: String

  func makeUIView(context: UIViewRepresentableContext<NumericTextField>) -> UITextField {
    textField.placeholder = placeholder
    textField.keyboardType = .numberPad
    textField.font = .systemRounded(style: .body, weight: .regular)
    textField.textAlignment = .right

    // When the user presses the done button, update the text binding, which sends the new text up the hierarchy
    // The coordinator is set in makeCoordinator() below, which uses a custom UITextField delegate defined in Helpers.swift that only accepts numeric 4 digit input
    textField.delegate = context.coordinator
    (textField.delegate as! NumericUITextFieldDelegate).didEndEditing = { text in self.text = text }

    // Configure autolayout so that text field doesn't expand
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

    return textField
  }

  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumericTextField>) {
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

struct ContentView_TestNumericTextField: View {
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
