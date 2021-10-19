//
//  NumericUITextFieldDelegate.swift
//  Tallybook
//
//  Created by Max Bickers on 12/15/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation
import SwiftUI

// Custom UITextField delegate that only allows numeric input
class NumericUITextFieldDelegate: NSObject, UITextFieldDelegate {
  @Binding var value: Int

  init(value: Binding<Int>) {
    _value = value
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.selectedTextRange = textField.textRange(
      from: textField.beginningOfDocument, to: textField.endOfDocument)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Lose focus when enter button pressed
    textField.resignFirstResponder()
    return false
  }

  func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    return CharacterSet(charactersIn: "0123456789").isSuperset(
      of: CharacterSet(charactersIn: string))
  }

  func textFieldDidChangeSelection(_ textField: UITextField) {
    DispatchQueue.main.async {
      if let text = textField.text,
        let newValue = Int(text)
      {
        self.value = newValue
      }
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == nil || textField.text! == "" {
      value = 0
    }

    textField.text = String(value)
  }
}
