//
//  UIDevice+vibrate.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import UIKit

extension UIDevice {
  static func vibrate() {
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
}
