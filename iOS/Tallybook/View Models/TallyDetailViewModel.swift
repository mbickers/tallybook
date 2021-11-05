//
//  TallyDetailViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 11/4/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

class TallyDetailViewModel: ObservableObject {
  @Published private(set) var tally: Tally

  init(tally: Tally) {
    self.tally = tally
  }

  func deleteEntries(atOffsets offsets: IndexSet) {
    tally.entries.remove(atOffsets: offsets)
  }

  func removeEntry(_ entry: Tally.Entry) {
    tally.removeEntry(entry)
  }

  func updateEntry(_ entry: Tally.Entry) {
    tally.updateEntry(entry)
  }
}
