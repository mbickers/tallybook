//
//  TallyViewDetail.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// Tally Detail View
struct TallyDetailView: View {
    
    @ObservedObject var tally: Tally
    
    // TallyDatum UUID is passed to the edit tally datum view through this binding.
    // When it is nil, it means that no tally datum was selected and that the edit tally datum view should be adding, rather than editing
    @State private var selectedTallyDatumID: UUID? = nil
    @State private var showingEditTallyDatum = false;
    
    
    init(tally: Tally) {
        self.tally = tally
    }
    
    static let df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy"
        return df
    }()
    
    var body: some View {             
        VStack {
            // Tally detail header with statistics at the top of the view
            TallyDetailHeader(tally: tally)
            
            // List of Tally Datums
            List {
                Section(header: Text("All Recorded Data")) {
                    ForEach(tally.data, id: \.id) { tallyDatum in
                        
                        // Because seperators are disabled for the main view, and that is a global setting in SwiftUI, seperators are implemented manually here
                        VStack {                            
                            // Invisible seperator at the top for visual balance
                            Rectangle()
                                .foregroundColor(Color(UIColor.clear))
                                .frame(height: 1)
                            
                            // Open edit tally screen
                            Button(action: {
                                self.selectedTallyDatumID = tallyDatum.id
                                self.showingEditTallyDatum = true
                            }) {
                                HStack {
                                    if self.tally.kind == .completion {
                                        Text(tallyDatum.boolValue ? "Complete" : "Incomplete")
                                            .foregroundColor(Color(UIColor.label))
                                    } else {
                                        Text(tallyDatum.defaultZeroStringValue)
                                            .foregroundColor(Color(UIColor.label))
                                    }
                                    Spacer()
                                    Text(TallyDetailView.df.string(from: TallyDatum.df.date(from: tallyDatum.date)!))
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                        .padding(.trailing, 15)
                                }
                            }                        
                            
                            // Add seperator at the bottom of each list item
                            if tallyDatum.id != self.tally.data.last?.id {
                                Rectangle()
                                    .foregroundColor(Color(UIColor.opaqueSeparator))
                                    .frame(height: 1)
                            } else {
                                Rectangle()
                                    .foregroundColor(Color(UIColor.clear))
                                    .frame(height: 1)
                            }
                        }
                    }
                    // Slide to delete functionality
                    .onDelete { sources in
                        withAnimation() {
                            self.tally.data.remove(atOffsets: sources)
                        }
                    }
                    // Have to manually specify insets and padding to avoid bug where List jumps around
                    .listRowInsets(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                }
            }
            // In order for the inset grouped style to be changed, the size class has to be manually changed
            .environment(\.horizontalSizeClass, .regular)
            .listStyle(GroupedListStyle())
            
        }
            
        // Configure navigation bar
        .navigationBarItems(trailing:
            Button(action: {
                self.selectedTallyDatumID = nil
                self.showingEditTallyDatum = true
            }) {
                Text("Add Data")
                    .padding([.vertical, .leading])
        })
        .navigationBarTitle(Text(tally.name), displayMode: .inline)
        
        // Add/Edit Tally Sheet
        .sheet(isPresented: $showingEditTallyDatum) {
            EditTallyDatumView(presenting: self.$showingEditTallyDatum,
                               tally: self.tally,
                               selectedTallyDatumID: self.$selectedTallyDatumID)
        }
    }
}











struct TallyViewDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        TallyDetailView(tally: UserData.TestData().tallies[0])
    }
}
