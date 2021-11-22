//
//  TallyRowViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 10/29/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine

class TallyRowViewModel: ObservableObject {
  private let repository = AppDelegate.shared.repository
  @Published private(set) var tally: Tally
  private var cancellables = Set<AnyCancellable>()

  init(tally: Tally) {
    self.tally = tally
  }

  var todayValue: Int {
    get {
      return tally.entries.todayValue
    }

    set {
      tally.entries.todayValue = newValue
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
