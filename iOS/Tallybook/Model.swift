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
  var name: String
  var kind: Kind
  var entries = [Entry]()

  struct Entry: Codable {
    var date: String
    var value: Int
  }
}

extension Tally.Entry {
  static let df: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  static var today: String {
    df.string(from: Date())
  }

  init(_ date: Date, value: Int) {
    self.date = Tally.Entry.df.string(from: date)
    self.value = min(9999, value)
  }
}

extension Tally {
  mutating func updateEntry(_ entry: Tally.Entry) {
    let index = entries.firstIndex { entry.date >= $0.date }
    if let index = index,
      entry.date == entries[index].date
    {
      if entry.value == 0 {
        entries.remove(at: index)
      } else {
        entries[index] = entry
      }
    } else {
      if entry.value == 0 {
        return
      } else {
        if let index = index {
          entries.insert(entry, at: index)
        } else {
          entries.append(entry)
        }
      }
    }

    //repository.updateTally(tally)
  }

  mutating func removeEntry(_ entry: Tally.Entry) {
    entries.removeAll { $0.date == entry.date }

    // update repository?
  }

  var today: Tally.Entry {
    get {
      return entries.first { Tally.Entry.today >= $0.date } ?? Tally.Entry(Date(), value: 0)
    }

    set {
      updateEntry(newValue)
    }
  }
}
