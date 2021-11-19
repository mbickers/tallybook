//
//  EntryList.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

struct EntryList: Codable {
  private static let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
  }()

  private struct Entry: Codable {
    let formattedDate: String
    let value: Int
  }
  private var entries = [Entry]()

  init() {}

  init(_ entries: [TallyEntry]) {
    for entry in entries {
      self[entry.date] = entry.value
    }
  }

  subscript(date: Date) -> Int {
    get {
      let formattedDate = EntryList.dateFormatter.string(from: date)
      let entry = entries.first { $0.formattedDate == formattedDate }
      return entry?.value ?? 0
    }

    set(value) {
      let formattedDate = EntryList.dateFormatter.string(from: date)
      entries.removeAll { $0.formattedDate == formattedDate }
      if value != 0 {
        let newEntry = Entry(formattedDate: formattedDate, value: value)
        entries.append(newEntry)
        entries.sort { $0.formattedDate > $1.formattedDate }
      }
    }
  }

  mutating func removeEntry(onDate date: Date) {
    self[date] = 0
  }

  mutating func removeEntries(atOffsets offsets: IndexSet) {
    entries.remove(atOffsets: offsets)
  }

  var todayValue: Int {
    get {
      return self[Date()]
    }

    set(value) {
      self[Date()] = value
    }
  }

  var allEntries: [TallyEntry] {
    return entries.map { entry in
      let date = EntryList.dateFormatter.date(from: entry.formattedDate)!
      return (date, entry.value)
    }
  }
}
