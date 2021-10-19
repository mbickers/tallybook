//
//  NumericTallyTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/2/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// SwiftUI wrapper of UITextField used in TallyRow. Numeric input only and selects existing text when editing begins.
struct NumericTallyTextField: UIViewRepresentable {
  private let textField = NumericTallyTextField.NumericUITextField()
  @Binding var value: Int

  // Subclass of UITextField that makes cursor slightly smaller so that it fits in TallyBlock without interfering with nearby sibling views
  class NumericUITextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
      var rect = super.caretRect(for: position)
      rect.size.height = 80
      rect = rect.offsetBy(dx: 0, dy: 20)
      return rect
    }
  }

  func makeUIView(context: UIViewRepresentableContext<NumericTallyTextField>) -> UITextField {
    textField.keyboardType = .numberPad
    textField.font = .systemRounded(size: 99, weight: .regular)
    textField.placeholder = "0"

    textField.delegate = context.coordinator

    // Add toolbar that shows done button above keyboard
    let toolbar = UIToolbar(
      frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    toolbar.barStyle = .default

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(
      title: "Done", style: .done, target: textField,
      action: #selector(textField.resignFirstResponder))

    let buttonFont = UIFont.systemRounded(style: .body, weight: .regular)
    let attributes: [NSAttributedString.Key: Any] = [
      .font: buttonFont,
      .foregroundColor: UIColor.customAccent,
    ]

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

  func updateUIView(
    _ uiView: UITextField, context: UIViewRepresentableContext<NumericTallyTextField>
  ) {
    uiView.text = String(value)
  }

  func makeCoordinator() -> NumericUITextFieldDelegate {
    return NumericUITextFieldDelegate(value: $value)
  }

}

struct ContentView_TestNumericTallyTextField: View {
  @State var beans = 12

  var body: some View {
    VStack {
      Text("Beans: \(beans)")

      NumericTallyTextField(value: $beans)
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
  }
}

struct NumericTallyTextField_Previews: PreviewProvider {
  static var previews: some View {
    ContentView_TestNumericTallyTextField()
  }
}
