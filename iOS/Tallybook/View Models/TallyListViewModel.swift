//
//  TallyListViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 9/26/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine
import Foundation

class TallyListViewModel: ObservableObject {
  private var repository: Repository = AppDelegate.shared.repository
  @Published private(set) var tallies = [TallyRowViewModel]()
  private var cancellables = Set<AnyCancellable>()

  init() {
    repository.publisher.map { tallies in
      tallies.map(TallyRowViewModel.init)
    }
    .assign(to: \.tallies, on: self)
    .store(in: &cancellables)
  }

  func moveTallies(fromOffsets sources: IndexSet, toOffset destination: Int) {
    var newTallies = tallies.map(\.tally)
    newTallies.move(fromOffsets: sources, toOffset: destination)
    newTallies.enumerated().forEach { (idx, tally) in
      var newTally = tally
      newTally.listPriority = idx
      repository.updateTally(newTally)
    }
  }

  func deleteTallies(atOffsets offsets: IndexSet) {
    let talliesToRemove = offsets.map { idx in tallies[idx].tally }
    talliesToRemove.forEach(repository.removeTally)
  }

  func addTally(_ tally: Tally) {
    repository.addTally(tally)
  }
}
