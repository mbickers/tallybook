//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Combine
import Foundation

typealias TallyEntry = (date: Date, value: Int)

struct Tally: Identifiable {
  enum Kind: String, CaseIterable {
    case completion = "Completion"
    case counter = "Counter"
    case amount = "Amount"
  }

  var id = UUID.init()
  var name = ""
  var kind = Kind.completion
  var entries = EntryList()
  var listPriority = 0
}

extension Tally {
  mutating func updateEntry(_ entry: TallyEntry) {
    entries[entry.date] = entry.value
  }

  mutating func removeEntry(_ entry: TallyEntry) {
    entries.removeEntry(onDate: entry.date)
  }
}
