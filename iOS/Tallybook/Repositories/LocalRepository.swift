//
//  LocalRepository.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine
import Foundation

class LocalRepository: Repository {
  var publisher: AnyPublisher<[Tally], Never> {
    return tallies.eraseToAnyPublisher()
  }

  private var tallies: CurrentValueSubject<[Tally], Never>

  init() {
    if let data = UserDefaults().data(forKey: "tallies"),
      let tallies = try? JSONDecoder().decode([Tally].self, from: data)
    {
      self.tallies = CurrentValueSubject(tallies)
    } else {
      tallies = CurrentValueSubject([Tally]())
    }
  }

  func addTally(_ tally: Tally) {
    tallies.value.append(tally)

    updateDisk()
  }

  func removeTally(_ tally: Tally) {
    if let index = tallies.value.firstIndex(where: { $0.id == tally.id }) {
      tallies.value.remove(at: index)
    }

    updateDisk()
  }

  func updateTally(_ tally: Tally) {
    if let index = tallies.value.firstIndex(where: { $0.id == tally.id }) {
      tallies.value[index] = tally
    }

    tallies.value.sort { lhs, rhs in
      return lhs.listPriority < rhs.listPriority
    }

    updateDisk()
  }

  private func updateDisk() {
    guard let data = try? JSONEncoder().encode(tallies.value) else {
      print("Unable to serialize tallies")
      return
    }

    UserDefaults().set(data, forKey: "tallies")
  }
}
