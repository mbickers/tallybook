//
//  TallyViewDetail.swift
//  Tallybook
//
//  Created by Max Bickers on 11/25/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyDetailView: View {
    
    @Binding var tally: Tally
    
    @State var selectedTallyDatumID: UUID? = nil
    @State var showingEditTallyDatum = false;
    
    var body: some View {
        List {
            Section(header: Text("All Recorded Data")) {
                ForEach(tally.data) { tallyDatum in
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
                                Text(String(tallyDatum.value))
                                    .foregroundColor(Color(UIColor.label))
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
        
        // Configure navigation bar
        .navigationBarItems(trailing:
            Button(action: {
                self.selectedTallyDatumID = nil
                self.showingEditTallyDatum = true
            }) {
                Text("Add Data")
                    .padding([.vertical, .leading])
            })
        .navigationBarTitle(tally.name)
        
        .sheet(isPresented: $showingEditTallyDatum) {
            EditTallyDatumView(presenting: self.$showingEditTallyDatum,
                               tally: self.$tally,
                               selectedTallyDatumID: self.$selectedTallyDatumID)
        }
        .navigationBarTitle(tally.name)
        
    }
}

struct TallyViewDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        EmptyView()
        //TallyDetailView(tally: UserData.testData.tallies[0])
    }
}
