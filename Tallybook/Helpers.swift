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
