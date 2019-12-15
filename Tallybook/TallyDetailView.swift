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
    
    @State var selectedTallyDatumID: UUID? = nil
    @State var showingEditTallyDatum = false;
    
    init(tally: Tally) {
        self.tally = tally
    }
    
    var body: some View {             
        VStack {
            TallyDetailHeader(tally: tally)
            
            List {
                
                Section(header: Text("All Recorded Data")) {
                    ForEach(tally.data, id: \.id) { tallyDatum in
                        VStack {
                            // Because seperators are disabled for the main view, and that is a global setting in SwiftUI, seperators are implemented manually here
                            
                            // Invisible seperator at the top for visual balance
                            Rectangle()
                                .foregroundColor(Color(UIColor.clear))
                                .frame(height: 1)
                            
                            // This button should make the list row highlight, will add later
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
                                    Text(tallyDatum.date)
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                        .padding(.trailing, 15)
                                }
                            }                        
                            
                            // Manually add seperator at the bottom of each list item
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
            
            .sheet(isPresented: $showingEditTallyDatum) {
                EditTallyDatumView(presenting: self.$showingEditTallyDatum,
                                   tally: self.tally,
                                   selectedTallyDatumID: self.$selectedTallyDatumID)
            }        
    }
}

struct TallyViewDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        TallyDetailView(tally: UserData.testData.tallies[0])
    }
}
