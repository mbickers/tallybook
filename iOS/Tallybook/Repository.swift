//
//  Repository.swift
//  Tallybook
//
//  Created by Max Bickers on 9/26/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

class BaseRepository {
  @Published var tallies = [Tally]()
}

protocol TallyRepository: BaseRepository {
  func addTally(_ tally: Tally)
  func removeTally(_ tally: Tally)
  func updateTally(_ tally: Tally)
}

class TestRepository: BaseRepository, TallyRepository, ObservableObject {
  private override init() {
    super.init()
    tallies = testData()
  }

  static let shared = TestRepository()

  func addTally(_ tally: Tally) {
    tallies.append(tally)
  }

  func removeTally(_ tally: Tally) {
    if let index = tallies.firstIndex(where: { $0.id == tally.id }) {
      tallies.remove(at: index)
    }
  }

  func updateTally(_ tally: Tally) {
    if let index = tallies.firstIndex(where: { $0.id == tally.id }) {
      tallies[index] = tally
    }
  }
}

private func testData() -> [Tally] {
  // Generate dummy date data
  var day = Date()

  let dummy_values = [2, 3, 5, 0, 1, 10, 2, 0, 12, 2, 6]
  var data = [Tally.Entry]()

  for v in dummy_values {
    data.append(Tally.Entry(day, value: v))
    day.addTimeInterval(-2 * 24 * 3600)
  }

  return [
    Tally(name: "Go to Gym", kind: .completion, entries: data),
    Tally(name: "Cups of Coffee", kind: .counter, entries: data),
    Tally(name: "Hours of Sleep", kind: .amount, entries: data),
    Tally(name: "Check Email", kind: .completion, entries: data),
    Tally(name: "Call Mom", kind: .completion, entries: data),
  ]
}
