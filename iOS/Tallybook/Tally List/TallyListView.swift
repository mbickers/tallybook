//
//  TallyListView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI
import UIKit

struct TallyListView: View {
  @StateObject private var tallyListViewModel = TallyListViewModel()
  @State private var showingAddTally = false
  @State private var editMode = EditMode.inactive

  var body: some View {
    NavigationView {
      List {
        ForEach(tallyListViewModel.tallies) { tallyRowViewModel in
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
          EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("\(Image(systemName: "plus"))") {
            showingAddTally = true
          }
        }
      }
      .navigationBarTitle("Tallies")
      .environment(\.editMode, $editMode)
      .sheet(isPresented: $showingAddTally) {
        EditTallyView(tally: Tally(), onCommit: tallyListViewModel.addTally)
      }

    }
    .navigationViewStyle(StackNavigationViewStyle())
    .font(Font.system(.body, design: .rounded))
    .accentColor(.customAccent)
  }

}

struct TallyListView_Previews: PreviewProvider {
  static var previews: some View {
    TallyListView()
  }
}
