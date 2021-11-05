//
//  TallyRowViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 10/29/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine
import Foundation

class TallyRowViewModel: ObservableObject {
  private let repository = Injected.repository
  @Published private(set) var tally: Tally
  private var cancellables = Set<AnyCancellable>()

  init(tally: Tally) {
    self.tally = tally
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
      repository.updateTally(tally)
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
