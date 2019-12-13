//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation

struct TallyDatum: Identifiable {
    var id = UUID()
    
    var date: String
    var value: Int
    
    var intValue: Int {
        get {
            return value
        }
        
        mutating set {
            value = min(9999, newValue)
        }
    }
    
    var defaultBlankStringValue: String {
        get {
            if intValue == 0 {
                return ""
            } else {
                return String(intValue)
            }
        }
        
        set {
            intValue = Int(newValue) ?? 0
        }
    }
    
    var defaultZeroStringValue: String {
        get {
            return String(intValue)
        }
        
        set {
            intValue = Int(newValue) ?? 0
        }
    }
    
    var boolValue: Bool {
        get {
            return intValue >= 1
        }
        
        set {
            intValue = newValue ? 1 : 0
        }
    }
    
    
    static var df: DateFormatter = {
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //TODO: Update to use combine to broadcast change on date change
    static var today: String {
        get {
            df.string(from: Date())
        }
    }
    
    init(date: Date, value: Int) {
        self.date = TallyDatum.df.string(from: date)
        self.value = min(9999, value)
    }
    
    init(date: String, value: Int) {
        self.date = date
        self.value = min(9999, value)
    }
}


class Tally: Identifiable, ObservableObject {
    
    enum Kind: String, CaseIterable {
        case completion = "Completion", counter = "Counter", amount = "Amount"
    }
    
    @Published var kind: Kind
    @Published var name: String = "Test"
    @Published var data: [TallyDatum]
    let id = UUID()
    
    init(kind: Kind, name: String, data: [TallyDatum]) {
        self.kind = kind
        self.name = name
        self.data = data
    }
    
    
    var today: TallyDatum {
        get {
            if data.count == 0 || data[0].date != TallyDatum.today {
                data.append(TallyDatum(date: Date(), value: 0))
            }
            
            return data[0]
        }
        
        set {
            data[0] = newValue
        }
    }
}


class UserData: ObservableObject {
    @Published var tallies: [Tally] = []
    
    init() {
        
    }
    
    static let testData: UserData = {
        // Generate dummy date data
        var day = Date();

        let dummy_values = [2, 3, 5, 0, 1, 10, 2, 0, 12, 2, 6];
        var data = [TallyDatum]()
        
        for v in dummy_values {
            data.append(TallyDatum(date: day, value: v))
            day.addTimeInterval(-2*24*3600)
        }
                
        
        let u  = UserData()
        u.tallies = [Tally(kind: .completion, name: "Go to Gym", data: data),
                     Tally(kind: .counter, name: "Cups of Coffee", data: data),
                     Tally(kind: .amount, name: "Weight", data: data),
                     Tally(kind: .amount, name: "Hours of Sleep", data: data),
                     Tally(kind: .counter, name: "Internship Rejections", data: data),
                     Tally(kind: .amount, name: "Beans", data: data)]
        return u
    }()
    
}
