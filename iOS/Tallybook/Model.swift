//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Combine
import Foundation

struct Tally: Identifiable, Codable {
  enum Kind: String, CaseIterable, Codable {
    case completion = "Completion"
    case counter = "Counter"
    case amount = "Amount"
  }

  var id = UUID.init()
  var name = ""
  var kind = Kind.completion
  var entries = [Entry]()
  var listPriority = 0

  struct Entry: Codable {
    var date: Date
    var value: Int
  }
}

extension Tally {
  mutating func updateEntry(_ entry: Tally.Entry) {
    entries.removeAll { $0.date == entry.date }
    if entry.value != 0 {
      entries.append(entry)
      entries.sort { $0.date > $1.date }
    }
  }

  mutating func removeEntry(_ entry: Tally.Entry) {
    entries.removeAll { $0.date == entry.date }
  }
}
