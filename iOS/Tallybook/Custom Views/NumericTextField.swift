//
//  NumericTextField.swift
//  Tallybook
//
//  Created by Max Bickers on 12/12/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// SwiftUI wrapper of UITextField used in EditTallyEntryView. Numeric input only, right-aligned, selects existing text when editing begins.
struct NumericTextField: UIViewRepresentable {
  private let textField = UITextField()
  @Binding var value: Int

  func makeUIView(context: UIViewRepresentableContext<NumericTextField>) -> UITextField {
    textField.keyboardType = .numberPad
    textField.font = .systemRounded(style: .body, weight: .regular)
    textField.placeholder = "0"
    textField.textAlignment = .right

    textField.delegate = context.coordinator

    // Configure autolayout so that text field doesn't expand
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

    return textField
  }

  func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<NumericTextField>) {
    uiView.text = String(value)
  }

  func makeCoordinator() -> NumericUITextFieldDelegate {
    return NumericUITextFieldDelegate(value: $value)
  }

}

struct ContentView_TestNumericTextField: View {
  @State var beans = 12

  var body: some View {
    VStack {
      Text("Beans: \(beans)")

      NumericTextField(value: $beans)
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
  }
}

struct NumericTextField_Previews: PreviewProvider {
  static var previews: some View {
    ContentView_TestNumericTextField()
  }
}
