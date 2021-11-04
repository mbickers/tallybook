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
  private var repository: TallyRepository = TestRepository.shared
  @Published private(set) var tallies = [TallyRowViewModel]()
  private var cancellables = Set<AnyCancellable>()

  init() {
    repository.$tallies.map { tallies in
      tallies.map(TallyRowViewModel.init)
    }
    .assign(to: \.tallies, on: self)
    .store(in: &cancellables)
  }

  func moveTallies(fromOffsets sources: IndexSet, toOffset destination: Int) {
    tallies.move(fromOffsets: sources, toOffset: destination)
  }

  func deleteTallies(atOffsets offsets: IndexSet) {
    tallies.remove(atOffsets: offsets)
  }

  func addTally(_ tally: Tally) {
    repository.addTally(tally)
  }
}
