//
//  Model.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Foundation

// Each tally datum represents the value of a tally on a date
struct TallyDatum: Identifiable {
    
    var id = UUID()
    
    // Dates are stored by string to avoid issues with time zone and manually setting time. Each tally datum corresponds to a specific date
    // The default date class includes time information that would overcomplicate this application
    var date: String
    
    
    private var value: Int
    
    // External access is only allowed through intValue wrapper in order to keep inputs within bounds
    var intValue: Int {
        get {
            return value
        }
        
        set {
            value = min(9999, newValue)
        }
    }
    
    
    // Beccause the tally datums use a custom string format, this is date formatter can be used to convert the string dates to more versatile date objects
    static let df: DateFormatter = {
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // Helper to find string version of today
    static var today: String {
        get {
            df.string(from: Date())
        }
    }
    
    // Function to validate numeric inputs. This is used in the delegates for the custom numeric keyboards
    static func validate(string: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        return digits.isSuperset(of: CharacterSet(charactersIn: string)) && string.count <= 4
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

// These calculated properties simply repetive logic whenever inputs are provided throught text fields
// Text fields can bind to specific tally datums, simplifying data flow
extension TallyDatum {
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
}

// Tally Class
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
    
    // TallyBlock relies depends on having data for today, while the tally detail view allows users to delete any tally datum, even the current one.
    // To overcome the potential issue there, the today TallyDatum is created by a Tally when it is needed, but only added to the model when it is set with a nonzero value
    // If its' value is set to zero, it is also removed from the model
    var today: TallyDatum {
        get {
            if let td = data.first, td.date == TallyDatum.today {
                return td
            } else {
                return TallyDatum(date: Date(), value: 0)
            }
        }
        
        set {
            if let td = data.first, td.date == TallyDatum.today {
                if newValue.intValue != 0 {
                    data[0].intValue = newValue.intValue
                } else {
                    data.removeFirst()
                }
            } else {
                if newValue.intValue != 0 {
                    data.insert(newValue, at: 0)
                }
            }
        }
    }
    
    
}


// UserData class: contains all information about the user's tallies
class UserData: ObservableObject {
    @Published var tallies: [Tally] = []
    
    init() {
        
    }
    
    // Fake data for testing
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
