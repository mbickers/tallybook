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
  @Published var repository: TallyRepository = TestRepository.shared
  @Published var tallies = [TallyRowViewModel]()

  init() {
    repository.$tallies.map { tallies in
      tallies.map(TallyRowViewModel.init)
    }
    .assign(to: \.tallies, on: self)
    .store(in: &cancellables)
  }

  private var cancellables = Set<AnyCancellable>()

  func addTally(_ tally: Tally) {
    repository.addTally(tally)
  }
}
