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
  var numericData = [Tally.Entry]()
  var completionData = [Tally.Entry]()

  for offset in stride(from: 0, through: -20, by: -2) {
    let day = Date().addingTimeInterval(TimeInterval(offset * 24 * 3600))
    numericData.append(Tally.Entry(day, value: Int.random(in: 1..<10)))
    completionData.append(Tally.Entry(day, value: 1))
  }

  return [
    Tally(name: "Go to Gym", kind: .completion, entries: completionData),
    Tally(name: "Cups of Coffee", kind: .counter, entries: numericData),
    Tally(name: "Hours of Sleep", kind: .amount, entries: numericData),
    Tally(name: "Check Email", kind: .completion, entries: completionData),
    Tally(name: "Call Mom", kind: .completion, entries: completionData),
  ]
}
