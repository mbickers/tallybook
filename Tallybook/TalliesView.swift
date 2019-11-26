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
    }
    
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(userData.tallies, id: \.kind) { tally in
                    TallyBlock(tally: tally)
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
        .accentColor(.green)
        
        
    }
}

struct TalliesView_Previews: PreviewProvider {
    static var previews: some View {
        TalliesView()
        .environmentObject(UserData())
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
