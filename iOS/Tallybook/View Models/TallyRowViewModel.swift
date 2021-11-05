//
//  TallyRowViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 10/29/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

class TallyRowViewModel: ObservableObject, Identifiable {
  @Published private(set) var tally: Tally

  init(tally: Tally) {
    // Note: Tally may not already exist in repository (such as in EditTallyView)
    self.tally = tally
    // Subscribe to updates from repository
  }

  var todayValue: Int {
    get {
      let todayEntry = tally.entries.first { Date.today() == $0.date }
      return todayEntry?.value ?? 0
    }

    set {
      var todayEntry =
        tally.entries.first { Date.today() == $0.date } ?? Tally.Entry(date: Date.today(), value: 0)
      todayEntry.value = newValue
      tally.updateEntry(todayEntry)
    }
  }

  func toggleTodayValue() {
    if todayValue == 0 {
      todayValue = 1
    } else {
      todayValue = 0
    }
  }
}
