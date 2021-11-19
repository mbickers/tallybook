//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation

typealias TallyEntry = (date: Date, value: Int)

struct Tally: Identifiable, Codable {
  enum Kind: String, CaseIterable, Codable {
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
