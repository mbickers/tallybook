//
//  CustomAutofocusTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/5/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// SwiftUI compatibible wrapper of UITextField that automatically becomes first responder, so that the keyboard comes up when the text field appears on screen
struct AutofocusTextField: UIViewRepresentable {
  private let textField = UITextField(frame: .zero)
  @Binding var text: String

  func makeUIView(context: UIViewRepresentableContext<AutofocusTextField>) -> UITextField {
    textField.textAlignment = .center
    textField.font = UIFont.systemRounded(style: .title1, weight: .semibold)

    textField.delegate = context.coordinator

    // Configure autolayout so that text field doesn't expand
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

    return textField
  }

  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<AutofocusTextField>)
  {
    // Make sure that the text field adjusts for changes to the state that originate from other parts of the app
    // This is done outside of the view update because setting the text during a view update can cause issues
    DispatchQueue.main.async {
      uiView.text = self.text
    }

    let coordinator = uiView.delegate as! AutofocusTextField.Coordinator
    if !coordinator.didBecomeFirstResponder {
      uiView.becomeFirstResponder()
      coordinator.didBecomeFirstResponder = true
    }
  }

  // Custom coordinator that updates text binding and stores
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

struct ContentView_TestAutofocusTextField: View {
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
