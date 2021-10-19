//
//  TallyDetailHeader.swift
//  Tallybook
//
//  Created by Max Bickers on 12/12/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// Header at the top of TallyDetailView that includes statistics about the tally data
struct TallyDetailHeader: View {
  enum Duration: String, CaseIterable {
    case week
    case month
    case allTime = "all time"
  }

  enum OverviewType: String, CaseIterable {
    case average
    case total
  }

  @Binding var tally: Tally
  @State private var duration = Duration.week
  @State private var overviewType = OverviewType.average

  func dateRange() -> (start: Date, end: Date, length: Int) {
    let end = Date()
    var start: Date!
    var length: Int!

    switch duration {
    case .week:
      start = Date().advanced(by: -7 * 24 * 3600)
      length = 7
    case .month:
      start = Date().advanced(by: -28 * 24 * 3600)
      length = 28
    case .allTime:
      if let date = tally.entries.last?.date {
        start = Tally.Entry.df.date(from: date)
        length = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        length = max(1, length)
      } else {
        start = end
        length = 1
      }
    }

    return (start, end, length)
  }

  func headerNumberText() -> String {
    let range = dateRange()

    let start = Tally.Entry.df.string(from: range.start)
    let end = Tally.Entry.df.string(from: range.end)

    let entries = tally.entries.filter { entry in entry.date >= start && entry.date <= end }

    let sum = entries.reduce(0) { $0 + $1.value }

    switch overviewType {
    case .average:
      if range.length == 0 {
        return "0"
      } else {
        if tally.kind == .completion {
          return String(format: "%.0f%%", 100 * Double(sum) / Double(range.length))
        }
        return String(format: "%.01f", Double(sum) / Double(range.length))
      }
    case .total:
      return String(sum)
    }
  }

  func headerDateText() -> String {
    let range = dateRange()

    let df: DateFormatter = DateFormatter()

    if Calendar.current.isDate(range.start, equalTo: range.end, toGranularity: .year) {
      df.dateFormat = "MMM dd"
    } else {
      df.dateFormat = "MMM dd, yyyy"
    }

    return "\(df.string(from: range.start)) – \(df.string(from: range.end))"
  }

  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(overviewType.rawValue.localizedUppercase)
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

        Spacer()
      }

      Picker(selection: $duration, label: Text("Duration")) {
        ForEach(Duration.allCases, id: \.self) { kind in
          Text(kind.rawValue.localizedCapitalized)
        }
      }
      .pickerStyle(SegmentedPickerStyle())

      Picker(selection: $overviewType, label: Text("Overview Type")) {
        ForEach(OverviewType.allCases, id: \.self) { kind in
          Text(kind.rawValue.localizedCapitalized)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
    }
    .padding([.horizontal, .top])
  }
}

struct ContentView_TallyDetailHeader: View {
  @State var tally = Tally(name: "Test", kind: .amount)

  var body: some View {
    TallyDetailHeader(tally: $tally)
  }
}

struct TallyDetailHeader_Previews: PreviewProvider {
  static var previews: some View {
    ContentView_TallyDetailHeader()
  }
}
