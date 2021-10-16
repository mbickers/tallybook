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
  @Published var tallies = [Tally]()

  init() {
    tallies = repository.tallies
  }

  private var cancellables = Set<AnyCancellable>()

  func addTally(_ tally: Tally) {
    tallies.append(tally)
  }
}
