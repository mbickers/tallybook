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
    
    @EnvironmentObject var userData: UserData
        
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemRounded(style: .largeTitle, weight: .bold)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemRounded(style: .headline, weight: .semibold)]
        
        UITableView.appearance().separatorStyle = .none
    }
    
    
    var body: some View {
        NavigationView {

            List() {
                ForEach(userData.tallies, id: \.id) { tally in
                    TallyBlock(tally: tally)
                    .listRowInsets(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                    
                }
                
                .onMove { source, destination in
                    self.userData.tallies.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { sources in
                    self.userData.tallies.remove(atOffsets: sources)
                }
                
                
                
                
            }
            
                
            .navigationBarItems(leading: EditButton(),
            trailing:
                Button(action: {  }) {
                Image(systemName: "plus")
                    .imageScale(.large)
            })
                
            .navigationBarTitle(Text("Tallies"))
            
        }
        .accentColor(Color(UIColor.systemGreen))
        
    }
    

}



extension UIFont {
    static func systemRounded(style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let size = UIFont.preferredFont(forTextStyle: style).pointSize
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded) 
        let font = UIFont(descriptor: descriptor!, size: size)
    
        return font
    }
}





struct TalliesView_Previews: PreviewProvider {
    static var previews: some View {
        TalliesView()
            .environmentObject(UserData.testData())
        .environment(\.colorScheme, .dark)
    }
}


