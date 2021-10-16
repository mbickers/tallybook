//
//  TallyEntryRow.swift
//  Tallybook
//
//  Created by Max Bickers on 10/16/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyEntryRow: View {
  @Binding var tally: Tally
  let entry: Tally.Entry
  @State private var showingEditEntrySheet = false

  var body: some View {
    Button(action: {
      showingEditEntrySheet = true
    }) {
      HStack {
        if tally.kind == .completion {
          Text(entry.value != 0 ? "Complete" : "Incomplete")
            .foregroundColor(Color(UIColor.label))
        } else {
          Text(String(entry.value))
            .foregroundColor(Color(UIColor.label))
        }
        Spacer()
        Text(entry.date)
          .foregroundColor(Color(UIColor.secondaryLabel))
          .padding(.trailing, 15)
      }
    }
    .sheet(isPresented: $showingEditEntrySheet) {
      EditTallyEntryView(
        tallyKind: tally.kind, entry: entry, mode: .edit,
        onCommit: { entry in
          tally.removeEntry(self.entry)
          tally.updateEntry(entry)
        })
    }
  }
}
