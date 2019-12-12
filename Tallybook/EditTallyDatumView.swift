//
//  EditTallyDatumView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/11/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct EditTallyDatumView: View {
    
    @Binding var presenting: Bool
    @ObservedObject var tally: Tally
    @Binding var selectedTallyDatumID: UUID?
    
    @State var tallyDatum: TallyDatum? = nil
    @State var isEditing: Bool = false
    
    @State var valueString: String = "0"
    @State private var date = Date()
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            // Header at top of view
            HStack {
                Button(action: {
                    self.selectedTallyDatumID = nil
                    self.presenting = false
                }, label: {
                    Text("Cancel")
                        .font(Font.system(.body, design: .rounded))
                })
                    .padding([.horizontal, .top])
                
                Spacer()
                
                Text((isEditing ? "Edit" : "Add") + " Tally Data")
                    .font(Font.system(.body, design: .rounded))
                    .bold()
                    .padding(.top)
                
                Spacer()
                
                Button(action: {
                    // Make changes
                    let value = Int(self.valueString) ?? 0
                    let dateString = TallyDatum.df.string(from: self.date)
                    if let idx = self.tally.data.firstIndex(where: { $0.date == dateString }) {
                        
                        self.tally.data[idx].value = value;
                        
                    } else {
                        let td = TallyDatum(date: dateString, value: value)
                        let idx = self.tally.data.firstIndex(where: { $0.date < dateString }) ?? self.tally.data.count
                        self.tally.data.insert(td, at: idx);
                        
                    }
                    // If same data is selected, add data to tallydatum that already exists for that day
                    
                    self.presenting = false
                }, label: {
                    Text(isEditing ? "Done" : "Add")
                        .font(Font.system(.body, design: .rounded))
                })
                    .padding([.horizontal, .top])
            }
            
            
            // Edit fields
            
            List {
                
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Value")
                        TextField("Value", text: self.$valueString)
                            .multilineTextAlignment(.trailing)
                    }
                    Divider()
                        .padding(.top, -5)
                        .padding(.trailing, -20)
                }
                .padding(.bottom, -10)

                
                VStack {
                    DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(WheelDatePickerStyle())
                    
                }
                
            }
            .listStyle(GroupedListStyle())
            
            
        }
        .accentColor(Color.customAccent)
        .onAppear() {
            // An editing ID is sometimes passed in from the controlling view.
            // Because this screen can function as either an add or edit screen, configure state accordingly
            if let td = self.tally.data.first(where: { $0.id == self.selectedTallyDatumID }) {
                self.tallyDatum = td
                self.isEditing = true
            } else {
                self.tallyDatum = TallyDatum(date: Date(), value: 0)
                self.isEditing = false
            }
        }
        
    }
}

struct EditTallyDatumView_Previews: PreviewProvider {
    static var previews: some View {
        EditTallyDatumView(presenting: .constant(true),
                           tally: Tally(kind: .counter, name: "Test", data: [TallyDatum]()),
                           selectedTallyDatumID: .constant(nil))
    }
}
