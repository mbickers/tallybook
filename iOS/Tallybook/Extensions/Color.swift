//
//  Color.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import SwiftUI

extension UIColor {
  static let customAccent: UIColor = UIColor(named: "AccentColor")!
}

extension Color {
  static let customAccent: Color = Color(UIColor.customAccent)
}
