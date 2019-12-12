//
//  TallyViewDetail.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyDetailView: View {
    
    @ObservedObject var tally: Tally
    
    init(tally: Tally) {
        self.tally = tally
    }
    
    var body: some View {
        List {
            Text("Placeholder")
        }
        .navigationBarTitle(tally.name)
    }
}

struct TallyViewDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        TallyDetailView(tally: UserData.testData.tallies[0])
    }
}
