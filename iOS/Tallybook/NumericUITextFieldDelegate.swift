//
//  NumericUITextFieldDelegate.swift
//  Tallybook
//
//  Created by Max Bickers on 12/15/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// Custom UITextField delegate that only allows legal input
class NumericUITextFieldDelegate: NSObject, UITextFieldDelegate {
  @Binding var text: String
  var didEndEditing: ((String) -> Void)?

  init(text: Binding<String>) {
    _text = text
  }

  func textFieldDidChangeSelection(_ textField: UITextField) {
    text = textField.text ?? ""
  }

  // Need to implement this in order to resign input when return key is pressed
  // This implementation doesn't effect the usage of the done button
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    // Make sure input is all digits and 4 characters or less
    let newText = (text as NSString).replacingCharacters(in: range, with: string)
    return TallyDatum.validate(string: newText)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    didEndEditing?(text)
  }
}
