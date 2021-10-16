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

  init() {
    // Configure navigation bar - not yet possible natively in SwiftUI
    // TODO: Update to do correctly when possible
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: UIFont.systemRounded(style: .largeTitle, weight: .bold)
    ]
    UINavigationBar.appearance().titleTextAttributes = [
      .font: UIFont.systemRounded(style: .headline, weight: .semibold)
    ]
  }

  var body: some View {
    NavigationView {

      List {
        ForEach($tallyListViewModel.tallies) { $tally in
          TallyRow(tally: $tally)
            .padding(EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 11))
            // Hack to hide list item separators on iOS 14
            // TODO: Fix in iOS 15
            .listRowInsets(EdgeInsets(.init(top: -1, leading: -1, bottom: -1, trailing: -1)))
            .background(Color(UIColor.systemBackground))
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
