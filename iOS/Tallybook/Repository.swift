//
//  Repository.swift
//  Tallybook
//
//  Created by Max Bickers on 9/26/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine
import Foundation

class Injected {
  static let repository: Repository = TestRepository()
}

protocol Repository {
  var publisher: AnyPublisher<[Tally], Never> { get }

  func addTally(_ tally: Tally)
  func removeTally(_ tally: Tally)
  func updateTally(_ tally: Tally)
}

class TestRepository: Repository {
  var publisher: AnyPublisher<[Tally], Never> {
    return tallies.eraseToAnyPublisher()
  }

  private var tallies: CurrentValueSubject<[Tally], Never>

  fileprivate init() {
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
  }
}

private func testData() -> [Tally] {
  var numericData = [Tally.Entry]()
  var completionData = [Tally.Entry]()

  for offset in stride(from: 0, through: -20, by: -2) {
    let day = Date().addingTimeInterval(TimeInterval(offset * 24 * 3600))
    numericData.append(Tally.Entry(date: day.truncatingTime(), value: Int.random(in: 1..<10)))
    completionData.append(Tally.Entry(date: day.truncatingTime(), value: 1))
  }

  return [
    Tally(name: "Go to Gym", kind: .completion, entries: completionData),
    Tally(name: "Cups of Coffee", kind: .counter, entries: numericData),
    Tally(name: "Hours of Sleep", kind: .amount, entries: numericData),
    Tally(name: "Check Email", kind: .completion, entries: completionData),
    Tally(name: "Call Mom", kind: .completion, entries: completionData),
  ]
}
