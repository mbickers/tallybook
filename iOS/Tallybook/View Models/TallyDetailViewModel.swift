//
//  TallyDetailViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 11/4/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

class TallyDetailViewModel: ObservableObject {
  private let repository = Injected.repository
  @Published private(set) var tally: Tally

  init(tally: Tally) {
    self.tally = tally
  }

  func deleteEntries(atOffsets offsets: IndexSet) {
    tally.entries.remove(atOffsets: offsets)
    repository.updateTally(tally)
  }

  func removeEntry(_ entry: TallyEntry) {
    tally.removeEntry(entry)
    repository.updateTally(tally)
  }

  func updateEntry(_ entry: TallyEntry) {
    tally.updateEntry(entry)
    repository.updateTally(tally)
  }

  func updateTally(_ tally: Tally) {
    if tally.kind == .completion {
      let entries = tally.entries.map { entry -> TallyEntry in
        var newEntry = entry
        newEntry.value = 1
        return newEntry
      }

      var newTally = tally
      newTally.entries = entries
      repository.updateTally(newTally)
    } else {
      repository.updateTally(tally)
    }
  }
}
