//
//  Helpers.swift
//  Tallybook
//
//  Created by Max Bickers on 12/2/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI


// Helper to have easy access to SF Rounded font
extension UIFont {
    static func systemRounded(style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let size = UIFont.preferredFont(forTextStyle: style).pointSize
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded) 
        let font = UIFont(descriptor: descriptor!, size: size)
    
        return font
    }
    
    static func systemRounded(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded) 
        let font = UIFont(descriptor: descriptor!, size: size)
    
        return font
    }
}


// Helper that accesses AccentColor font in Assets folder
extension UIColor {
    static let customAccent: UIColor = UIColor(named: "AccentColor")!
}

extension Color {
    static let customAccent: Color = Color(UIColor.customAccent)
}


// Helper to vibrate device
extension UIDevice {
    static func vibrate() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}


// Custom UITextField delegate that only allows legal input
class NumericUITextFieldDelegate: NSObject, UITextFieldDelegate {
    @Binding var text: String
    var didEndEditing: ((String)->Void)?
            
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Make sure input is all digits and 4 characters or less
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        return TallyDatum.validate(string: newText)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(text)
    }
}
