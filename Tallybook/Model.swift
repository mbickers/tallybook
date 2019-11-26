//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation

struct Tally {
    enum Kind {
        case completion, counter, amount
    }
    
    var kind: Kind


}


class UserData: ObservableObject {
    @Published var tallies: [Tally]
    
    init() {
        tallies = [Tally(kind: .completion), Tally(kind: .counter), Tally(kind: .amount)]
    }
}
