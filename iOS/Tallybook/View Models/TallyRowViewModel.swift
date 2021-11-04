//
//  TallyRowViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 10/29/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation
import UIKit

class TallyRowViewModel: ObservableObject, Identifiable {
  @Published var tally: Tally

  init(tally: Tally) {
    // Note: Tally may not already exist in repository (such as in EditTallyView)
    self.tally = tally
    // Subscribe to updates from repository
  }
}
