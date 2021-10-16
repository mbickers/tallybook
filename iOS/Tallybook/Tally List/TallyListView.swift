//
//  TalliesView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI
import UIKit

// Main screen on app
struct TallyListView: View {
  @ObservedObject var tallyListViewModel = TallyListViewModel()
  @State private var showingAddTally = false

  var body: some View {
    NavigationView {
      List {
        ForEach($tallyListViewModel.tallies) { $tally in
          TallyRow(tally: $tally)
            .background(Color(UIColor.systemBackground))
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

      .navigationBarItems(
        leading:
          EditButton()
          .font(Font.system(.body, design: .rounded))
          .padding([.vertical, .trailing]),
        trailing:
          Button(action: {
            self.showingAddTally = true
          }) {
            Image(systemName: "plus")
              .imageScale(.large)
              .padding([.vertical, .leading])
          }
      )
      .navigationBarTitle(Text("Tallies"))

      .sheet(isPresented: $showingAddTally) {
        EditTallyView(
          tally: Tally(name: "", kind: .completion),
          onCommit: { newTally in
            tallyListViewModel.tallies.append(newTally)
          })
      }

    }

    .accentColor(.customAccent)
    .navigationViewStyle(DoubleColumnNavigationViewStyle())
  }

}

struct TallyListView_Previews: PreviewProvider {
  static var previews: some View {
    TallyListView()
  }
}
