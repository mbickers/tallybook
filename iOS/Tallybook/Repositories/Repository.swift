//
//  Repository.swift
//  Tallybook
//
//  Created by Max Bickers on 9/26/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Combine

class Injected {
  static let repository: Repository = LocalRepository()
}

protocol Repository {
  var publisher: AnyPublisher<[Tally], Never> { get }

  func addTally(_ tally: Tally)
  func removeTally(_ tally: Tally)
  func updateTally(_ tally: Tally)
}
