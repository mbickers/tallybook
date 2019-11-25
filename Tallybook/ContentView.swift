//
//  ContentView.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView() {
            TallyBlock()
            
        }
        .background(Color(UIColor.systemGray4))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
