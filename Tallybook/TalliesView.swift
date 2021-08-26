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
struct TalliesView: View {

    @EnvironmentObject var userData: UserData

    @State private var showingAddTally = false

    init() {
        // Configure navigation bar - not yet possible natively in SwiftUI
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemRounded(style: .largeTitle, weight: .bold)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemRounded(style: .headline, weight: .semibold)]
    }

    var body: some View {

        NavigationView {

            // List of TallyBlocks
            List {
                ForEach(userData.tallies, id: \.id) { tally in
                    TallyBlock(tally: tally)
                        .padding(EdgeInsets(top: 7, leading: 11, bottom: 7, trailing: 11))
                        .listRowInsets(EdgeInsets(.init(top: -1, leading: -1, bottom: -1, trailing: -1)))
                        .background(Color(UIColor.systemBackground))
                }
                // Callbacks to allow tallies to be rearranged and deleted by the table view
                .onMove { source, destination in
                    self.userData.tallies.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { sources in
                    self.userData.tallies.remove(atOffsets: sources)
                }
            }
            .listStyle(PlainListStyle())

            // Configure navigation bar
            // EditButton has built in functionality that makes the list go into editing mode 
            .navigationBarItems(leading:
                EditButton()
                    .font(Font.system(.body, design: .rounded))
                    .padding([.vertical, .trailing]), trailing:
                Button(action: {
                    self.showingAddTally = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .padding([.vertical, .leading])
                })
            .navigationBarTitle(Text("Tallies"))

            // New Tally Modal Sheet
            .sheet(isPresented: $showingAddTally) {
                AddTallyView(presenting: self.$showingAddTally)
                    .environmentObject(self.userData)
            }

        }
        .accentColor(.customAccent)
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }

}

struct TalliesView_Previews: PreviewProvider {
    static var previews: some View {
        TalliesView()
            .environmentObject(UserData.TestData())
    }
}
