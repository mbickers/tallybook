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
        
        set {
            value = min(9999, newValue)
        }
    }
    
    var stringValue: String {
        get {
            if value == 0 {
                return ""
            } else {
                return String(value)
            }
        }
        
        set {
            intValue = Int(newValue) ?? 0
        }
    }
    
    var boolValue: Bool {
        get {
            return value >= 1
        }
        
        set {
            value = newValue ? 1 : 0
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
        self.value = value
        intValue = intValue
    }
    
    init(date: String, value: Int) {
        self.date = date
        self.value = value
        intValue = intValue
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
    

    var todayValue: Int? {
        get {
            if data.count > 0 && data[0].date == TallyDatum.today {
                return data[0].value
            }
            return nil
        }
        
        set {
            if data.count > 0 && data[0].date == TallyDatum.today {
                if let nv = newValue {
                    data[0].intValue = nv
                } else {
                    data.remove(at: 0)
                }
            } else if let nv = newValue {
                data.insert(TallyDatum(date: Date(), value: nv), at: 0)
            }
        }
    }
    
    // Wrappers to access values from today for convience in TallyBlock
    
    var completionToday: Bool {
        get {
            return (todayValue ?? 0) >= 1
        }
        
        set {
            todayValue = newValue ? 1 : nil
        }
    }
    
    var numericToday: Int {
        get {
            return todayValue ?? 0
        }
        
        set {
            todayValue = newValue
        }
    }
    
    var numericStringToday: String {
        get {
            if let tv = todayValue {
                return String(tv);
            } else {
                return "";
            }
        }
        
        set {
            if newValue == "" {
                todayValue = nil
            } else {
                todayValue = Int(newValue)
            }
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
