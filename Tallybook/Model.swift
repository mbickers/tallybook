//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation

class Tally: Identifiable {
    
    enum Kind {
        case completion, counter, amount
    }
    
    var kind: Kind
    var name: String = "Test"
    var values: [String : Int]
    let id: Int
    
    init(kind: Kind, name: String, values: [String : Int], id: Int) {
        self.kind = kind
        self.name = name
        self.values = values
        self.id = id
    }


}


class UserData: ObservableObject {
    @Published var tallies: [Tally] = []
    
    init() {
        
    }
    
    class func testData() -> UserData {
        let u = UserData()
        u.tallies = [Tally(kind: .completion, name: "Go to Gym", values: [String : Int](), id: 12),
                     Tally(kind: .counter, name: "Cups of Coffee", values: [String : Int](), id: 19),
                     Tally(kind: .amount, name: "Weight", values: [String : Int](), id: 3),
                     Tally(kind: .amount, name: "Hours of Sleep", values: [String : Int](), id: 500),
                     Tally(kind: .counter, name: "Internship Rejections", values: [String : Int](), id: 400),
                     Tally(kind: .amount, name: "Beans", values: [String : Int](), id: 42)]
        
        return u
    }
}
