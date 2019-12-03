//
//  TalliesView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI
import UIKit

struct TalliesView: View {
    
    @ObservedObject var userData: UserData = UserData.testData

        
    init() {
        // Configure navigation bar - not yet possible natively in SwiftUI
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemRounded(style: .largeTitle, weight: .bold)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemRounded(style: .headline, weight: .semibold)]
        
        // Configure tally list - not yet possible natively in SwiftUI
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    
    var body: some View {
        NavigationView {
            
            List() {
                ForEach(userData.tallies, id: \.id) { tally in
                    TallyBlock(tally: tally)
                    .listRowInsets(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                }
                // Callbacks to allow tallies to be rearranged and deleted by the table view
                .onMove { source, destination in
                    self.userData.tallies.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { sources in
                    self.userData.tallies.remove(atOffsets: sources)
                }
            }
            
            // Configure navigation bar
            // EditButton has built in functionality that makes the list go into editing mode 
            .navigationBarItems(leading: EditButton(),
            trailing:
                Button(action: {}) {
                Image(systemName: "plus")
                    .imageScale(.large)
            })
            .navigationBarTitle(Text("Tallies"))
            
        }
        .accentColor(Color(UIColor.systemGreen))

    }
    

}





struct TalliesView_Previews: PreviewProvider {
    static var previews: some View {
        TalliesView()
            .environment(\.colorScheme, .dark)
    }
}


