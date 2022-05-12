//
//  TallyListView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyListView: View {
  @StateObject private var tallyListViewModel = TallyListViewModel()
  @State private var showingAddTally = false
  @State private var editMode = EditMode.inactive

  var body: some View {
    NavigationView {
      List {
        ForEach(tallyListViewModel.tallies, id: \.tally.id) { tallyRowViewModel in
          if editMode == .active {
            Text(tallyRowViewModel.tally.name)
              .font(.system(size: 22, weight: .regular, design: .rounded))
              .listRowSeparator(.hidden)
          } else {
            TallyRow(viewModel: tallyRowViewModel)
          }
        }
        .onMove(perform: tallyListViewModel.moveTallies)
        .onDelete(perform: tallyListViewModel.deleteTallies)
      }
      .listStyle(PlainListStyle())

      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Menu("\(Image(systemName: "ellipsis.circle"))") {
            Button("Sign Out") {
              tallyListViewModel.signOut()
            }
          }
          .disabled(editMode == .active)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }

        ToolbarItem(placement: .bottomBar) {
          Button {
            showingAddTally = true
          } label: {
            Image(systemName: "plus.circle.fill")
            Text("Add a Tally")
          }
          .disabled(editMode == .active)
        }
      }
      .navigationBarTitle("Tallies")
      .environment(\.editMode, $editMode)
      .sheet(isPresented: $showingAddTally) {
        let newTally = Tally(listPriority: tallyListViewModel.tallies.count)
        EditTallyView(mode: .add, tally: newTally, onCommit: tallyListViewModel.addTally)
      }

    }
    .navigationViewStyle(.stack)
    .font(Font.system(.body, design: .rounded))
    .accentColor(.customAccent)
  }

}

struct TallyListView_Previews: PreviewProvider {
  static var previews: some View {
    TallyListView()
  }
}
