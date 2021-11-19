//
//  EntryList.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

struct EntryList {
  private static let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    return df
  }()

  private var entries = [(formattedDate: String, value: Int)]()

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
        let newEntry = (formattedDate, value)
        entries.append(newEntry)
        entries.sort { $0.formattedDate > $1.formattedDate }
      }
    }
  }

  mutating func removeEntry(onDate date: Date) {
    self[date] = 0
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
    return entries.map { (formattedDate: String, value: Int) in
      let date = EntryList.dateFormatter.date(from: formattedDate)!
      return (date, value)
    }
  }
}
