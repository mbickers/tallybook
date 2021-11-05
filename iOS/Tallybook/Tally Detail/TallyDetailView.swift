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

  var body: some View {
    VStack {
      TallyDetailHeader(viewModel: viewModel)

      List {
        Section("All Data") {
          ForEach(viewModel.tally.entries, id: \.date) { entry in
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
        tallyKind: viewModel.tally.kind, entry: Tally.Entry(date: Date.today(), value: 0),
        mode: .add,
        onCommit: viewModel.updateEntry)
    }
  }
}

struct TallyDetailView_Previews: PreviewProvider {

  static var previews: some View {
    TallyDetailView(viewModel: TallyDetailViewModel(tally: Tally()))
  }
}
