//
//  String+isValidEmail.swift
//  Tallybook
//
//  Created by Max Bickers on 12/3/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

extension String {
  var isValidEmail: Bool {
    let detector = try! NSDataDetector.init(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))

    return matches.count == 1 && matches.first!.url!.scheme == "mailto"
  }
}
