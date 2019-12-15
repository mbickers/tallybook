//
//  TallyGraphView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/12/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyDetailHeader: View {
    
    @ObservedObject var tally: Tally
    
    enum Duration: String, CaseIterable {
        case week = "Week", month = "Month", allTime = "All Time"
    }
    @State var duration: Duration = .week
    
    enum GraphBehavior: String, CaseIterable {
        case aggregate = "Aggregate", cumulative = "Cumulative"
    }
    @State var graphBehavior: GraphBehavior = .aggregate
    
    
    init(tally: Tally) {
        
        self.tally = tally
        
        // Change font of Segmented Control to rounded. Not possible in native SwiftUI yet
        let selectedFont = UIFont.systemRounded(style: .callout, weight: .semibold)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: selectedFont], for: .selected)
        
        let defaultFont = UIFont.systemRounded(style: .callout, weight: .regular)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: defaultFont], for: .normal)
    }
    
    
    func dateRange() -> (start: Date, end: Date, length: Int) {
        let end = Date()
        var start: Date!
        var length: Int!
                
        switch duration {
        case .week:
            start = Date().advanced(by: -7*24*3600)
            length = 7
        case .month:
            start = Date().advanced(by: -28*24*3600)
            length = 28
        case .allTime:
            if let date = tally.data.last?.date {
                start = TallyDatum.df.date(from: date)
                length = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
            } else {
                start = end
                length = 0
            }
        }
        
        return (start, end, length)
    }
    
    func headerLabel() -> String {
        switch graphBehavior {
        case .aggregate:
            return "AVERAGE"
        case .cumulative:
            return "TOTAL"
        }
    }
    
    func headerNumberText() -> String {
        let range = dateRange()
        
        let start = TallyDatum.df.string(from: range.start)
        let end = TallyDatum.df.string(from: range.end)
        
        let tallyDatums = tally.data.filter() { td in td.date >= start && td.date <= end }
        
        let sum = tallyDatums.reduce(0) { $0 + $1.value }
        
        switch graphBehavior {
        case .aggregate:
            if range.length == 0 {
                return "0"
            } else {
                return String(format: "%.01f", Double(sum)/Double(range.length))
            }
        case .cumulative:
            return String(sum)
        }
    }
    
    func headerDateText() -> String {
        let range = dateRange()
        
        let df: DateFormatter = DateFormatter();
        
        if Calendar.current.isDate(range.start, equalTo: range.end, toGranularity: .year) {
            df.dateFormat = "MMM dd"
        } else {
            df.dateFormat = "MMM dd, yyyy"
        }
        
        return "\(df.string(from: range.start)) - \(df.string(from: range.end))"
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(headerLabel())
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(headerNumberText())
                            .font(.system(.title, design: .rounded))
                        
                        Text(headerDateText())
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                }
                .padding(.leading)
                
                Spacer()
            }
            .padding(.top)
            
            Picker(selection: $duration, label: Text("Graph Duration")) {
                ForEach(Duration.allCases, id: \.self) { kind in
                    Text(kind.rawValue)
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            
            Picker(selection: $graphBehavior, label: Text("Graph Behavior")) {
                ForEach(GraphBehavior.allCases, id: \.self) { kind in
                    Text(kind.rawValue)
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
        }
    }
}

struct ContentView_TallyDetailHeader: View {    
    @State var tally = UserData.testData.tallies[0]
    
    var body: some View {
        TallyDetailHeader(tally: tally)
    }
}

struct TallyDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_TallyDetailHeader()
    }
}
