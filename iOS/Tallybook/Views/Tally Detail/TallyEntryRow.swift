//
//  TallyEntryRow.swift
//  Tallybook
//
//  Created by Max Bickers on 10/16/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyEntryRow: View {
  @ObservedObject var viewModel: TallyDetailViewModel
  let entry: TallyEntry
  @State private var showingEditEntrySheet = false

  var body: some View {
    Button {
      showingEditEntrySheet = true
    } label: {
      HStack {
        if viewModel.tally.kind == .completion {
          Text(entry.value != 0 ? "Complete" : "Incomplete")
            .foregroundColor(Color(UIColor.label))
        } else {
          Text(String(entry.value))
            .foregroundColor(Color(UIColor.label))
        }

        Spacer()

        Text(entry.date, style: .date)
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
    }
    .sheet(isPresented: $showingEditEntrySheet) {
      EditTallyEntryView(tallyKind: viewModel.tally.kind, entry: entry, mode: .edit) { entry in
        viewModel.removeEntry(self.entry)
        viewModel.updateEntry(entry)
      }
    }
  }
}

struct TallyEntryRow_Previews: PreviewProvider {
  static let entry = TallyEntry(date: Date(), value: 1)
  static var previews: some View {
    TallyEntryRow(
      viewModel: TallyDetailViewModel(tally: Tally(entries: EntryList([entry]))),
      entry: entry)
  }
}
