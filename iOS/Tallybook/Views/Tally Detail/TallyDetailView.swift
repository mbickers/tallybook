//
//  TallyDetailView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyDetailView: View {
  @ObservedObject var viewModel: TallyDetailViewModel
  @State private var showingAddEntrySheet = false
  @State private var showingEditTallySheet = false

  var body: some View {
    VStack {
      TallyDetailHeader(viewModel: viewModel)

      List {
        Button("Edit Tally") {
          showingEditTallySheet = true
        }

        Section("All Data") {
          ForEach(viewModel.tally.entries.allEntries, id: \.date) { entry in
            TallyEntryRow(viewModel: viewModel, entry: entry)
          }
          .onDelete(perform: viewModel.deleteEntries)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Add Data") {
          showingAddEntrySheet = true
        }
      }
    }
    .navigationBarTitle(Text(viewModel.tally.name), displayMode: .inline)

    .sheet(isPresented: $showingAddEntrySheet) {
      EditTallyEntryView(
        tallyKind: viewModel.tally.kind, entry: TallyEntry(date: Date(), value: 0),
        mode: .add,
        onCommit: viewModel.updateEntry)
    }

    .sheet(isPresented: $showingEditTallySheet) {
      EditTallyView(mode: .edit, tally: viewModel.tally, onCommit: viewModel.updateTally)
    }
  }
}

struct TallyDetailView_Previews: PreviewProvider {

  static var previews: some View {
    TallyDetailView(viewModel: TallyDetailViewModel(tally: Tally()))
  }
}
