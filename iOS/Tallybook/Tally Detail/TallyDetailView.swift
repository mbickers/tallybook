//
//  TallyViewDetail.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyDetailView: View {

  @Binding var tally: Tally
  @State private var showingAddEntrySheet = false

  var body: some View {
    VStack {
      TallyDetailHeader(tally: $tally)

      List {
        Section(header: Text("All Recorded Data")) {
          ForEach(tally.entries, id: \.date) { entry in
            TallyEntryRow(tally: $tally, entry: entry)
          }
          .onDelete { sources in
            withAnimation {
              //self.tally.data.remove(atOffsets: sources)
            }
          }
          // Have to manually specify insets and padding to avoid bug where List jumps around
          .listRowInsets(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
        }
      }
      // In order for the inset grouped style to be changed, the size class has to be manually changed
      .environment(\.horizontalSizeClass, .regular)
      .listStyle(GroupedListStyle())

    }

    .navigationBarItems(
      trailing:
        Button(action: {
          showingAddEntrySheet = true
        }) {
          Text("Add Data")
            .padding([.vertical, .leading])
        }
    )
    .navigationBarTitle(Text(tally.name), displayMode: .inline)

    .sheet(isPresented: $showingAddEntrySheet) {
      EditTallyEntryView(
        tallyKind: tally.kind, entry: Tally.Entry(Date(), value: 0), mode: .add,
        onCommit: { entry in tally.updateEntry(entry) })
    }
  }
}

struct TallyViewDetail_Previews: PreviewProvider {

  static var previews: some View {
    TallyDetailView(tally: .constant(Tally(name: "Test", kind: .completion)))
  }
}
