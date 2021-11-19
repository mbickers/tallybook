//
//  UIFont+systemRounded.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import UIKit

extension UIFont {
  static func systemRounded(style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
    let size = UIFont.preferredFont(forTextStyle: style).pointSize
    let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(
      .rounded)
    let font = UIFont(descriptor: descriptor!, size: size)

    return font
  }

  static func systemRounded(size: CGFloat, weight: UIFont.Weight) -> UIFont {
    let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(
      .rounded)
    let font = UIFont(descriptor: descriptor!, size: size)

    return font
  }
}
