//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation

class Tally: Identifiable, ObservableObject {
    
    enum Kind {
        case completion, counter, amount
    }
    
    var kind: Kind
    var name: String = "Test"
    var values: [String : Int]
    let id = UUID()
    
    init(kind: Kind, name: String, values: [String : Int]) {
        self.kind = kind
        self.name = name
        self.values = values
    }
    
    // Will be removed once the derived properties are based on values variable
    // This value is an optional because 0 means value of 0 and nil means user didn't set a value
    @Published var tempToday: Int?
    
    // Wrappers to access values from today for convience in TallyBlock
    
    var completionToday: Bool {
        get {
            return tempToday == 1
        }
        
        set {
            tempToday = newValue ? 1 : nil
        }
    }
    
    var numericToday: Int {
        get {
            return tempToday ?? 0
        }
        
        set {
            tempToday = newValue
        }
    }
    
    var numericStringToday: String? {
        get {
            return tempToday != nil ? String(tempToday!) : ""
        }
        
        set {
            tempToday = Int(newValue ?? "")
        }
    }
}


class UserData: ObservableObject {
    @Published var tallies: [Tally] = []
    
    init() {
        
    }
    
    static let testData: UserData = {
        let u  = UserData()
        u.tallies = [Tally(kind: .completion, name: "Go to Gym", values: [String : Int]()),
                     Tally(kind: .counter, name: "Cups of Coffee", values: [String : Int]()),
                     Tally(kind: .amount, name: "Weight", values: [String : Int]()),
                     Tally(kind: .amount, name: "Hours of Sleep", values: [String : Int]()),
                     Tally(kind: .counter, name: "Internship Rejections", values: [String : Int]()),
                     Tally(kind: .amount, name: "Beans", values: [String : Int]())]
        return u
    }()
    
}
