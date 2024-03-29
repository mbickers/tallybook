//
//  TestRepository.swift
//  Tallybook
//
//  Created by Max Bickers on 11/19/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine
import Foundation

class TestRepository: Repository {
  var publisher: AnyPublisher<[Tally], Never> {
    return tallies.eraseToAnyPublisher()
  }

  private var tallies: CurrentValueSubject<[Tally], Never>

  init() {
    tallies = CurrentValueSubject(testData())
  }

  func addTally(_ tally: Tally) {
    tallies.value.append(tally)
  }

  func removeTally(_ tally: Tally) {
    if let index = tallies.value.firstIndex(where: { $0.id == tally.id }) {
      tallies.value.remove(at: index)
    }
  }

  func updateTally(_ tally: Tally) {
    if let index = tallies.value.firstIndex(where: { $0.id == tally.id }) {
      tallies.value[index] = tally
    }

    tallies.value.sort { lhs, rhs in
      return lhs.listPriority < rhs.listPriority
    }
  }
}

private func testData() -> [Tally] {
  var numericData = [TallyEntry]()
  var completionData = [TallyEntry]()

  for offset in stride(from: 0, through: -20, by: -2) {
    let day = Date().addingTimeInterval(TimeInterval(offset * 24 * 3600))
    numericData.append(TallyEntry(date: day, value: Int.random(in: 1..<10)))
    completionData.append(TallyEntry(date: day, value: 1))
  }

  return [
    Tally(name: "Go to Gym", kind: .completion, entries: EntryList(completionData)),
    Tally(name: "Cups of Coffee", kind: .counter, entries: EntryList(numericData)),
    Tally(name: "Hours of Sleep", kind: .amount, entries: EntryList(numericData)),
    Tally(name: "Check Email", kind: .completion, entries: EntryList(completionData)),
    Tally(name: "Call Mom", kind: .completion, entries: EntryList(completionData)),
  ]
}
