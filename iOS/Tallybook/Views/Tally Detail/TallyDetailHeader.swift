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

  @ObservedObject var viewModel: TallyDetailViewModel
  @State private var duration = Duration.week
  @State private var overviewType = OverviewType.average

  func dateRange() -> (start: Date, end: Date, length: Int) {
    switch duration {
    case .week:
      return (Date().advanced(by: -7 * 24 * 3600), Date(), 28)

    case .month:
      return (Date().advanced(by: -28 * 24 * 3600), Date(), 28)

    case .allTime:
      if let start = viewModel.tally.entries.allEntries.last?.date {
        let length = max(
          Calendar.current.dateComponents([.day], from: start, to: Date()).day ?? 0, 1)
        return (start, Date(), length)
      } else {
        return (Date(), Date(), 1)
      }
    }
  }

  func headerNumberText() -> String {
    let range = dateRange()

    let entries = viewModel.tally.entries.allEntries.filter { entry in
      entry.date >= range.start && entry.date <= range.end
    }

    let sum = entries.reduce(0) { $0 + $1.value }

    switch overviewType {
    case .average:
      if range.length == 0 {
        return "0"
      } else {
        if viewModel.tally.kind == .completion {
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
  var body: some View {
    TallyDetailHeader(viewModel: TallyDetailViewModel(tally: Tally()))
  }
}

struct TallyDetailHeader_Previews: PreviewProvider {
  static var previews: some View {
    ContentView_TallyDetailHeader()
  }
}
