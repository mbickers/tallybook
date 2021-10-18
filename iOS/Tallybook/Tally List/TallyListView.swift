//
//  TalliesView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI
import UIKit

struct TallyListView: View {
  @ObservedObject private var tallyListViewModel = TallyListViewModel()
  @State private var showingAddTally = false

  var body: some View {
    NavigationView {
      List {
        ForEach($tallyListViewModel.tallies) { $tally in
          TallyRow(tally: $tally)
            .listRowSeparator(.hidden)
        }
        .onMove { source, destination in
          //self.userData.tallies.move(fromOffsets: source, toOffset: destination)
        }
        .onDelete { sources in
          //self.userData.tallies.remove(atOffsets: sources)
        }
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

      .sheet(isPresented: $showingAddTally) {
        EditTallyView(
          tally: Tally(name: "", kind: .completion),
          onCommit: tallyListViewModel.addTally)
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
