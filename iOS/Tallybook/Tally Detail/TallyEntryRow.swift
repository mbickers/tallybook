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
  let entry: Tally.Entry
  @State private var showingEditEntrySheet = false

  var body: some View {
    Button {
      showingEditEntrySheet = true
    } label: {
      HStack {
        if viewModel.tally.kind == .completion {
          Text(entry.boolValue ? "Complete" : "Incomplete")
            .foregroundColor(Color(UIColor.label))
        } else {
          Text(String(entry.value))
            .foregroundColor(Color(UIColor.label))
        }

        Spacer()

        Text(entry.date)
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
  static var previews: some View {
    TallyEntryRow(
      viewModel: TallyDetailViewModel(tally: Tally(entries: [Tally.Entry(Date(), value: 1)])),
      entry: Tally.Entry(Date(), value: 1))
  }
}
