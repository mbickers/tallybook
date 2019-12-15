//
//  EditTallyDatumView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/11/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// View to Add/Edit Tally Datums
struct EditTallyDatumView: View {
    
    // Variables passed in through parent view
    @Binding var presenting: Bool
    @ObservedObject var tally: Tally
    
    // If a tally datum is being edited, its UUID is passed in. If this value is in nil, the view is in add mode
    @Binding var selectedTallyDatumID: UUID?
    
    // isEditing shows whether the view is in add or edit mode
    @State private var isEditing: Bool = false
    
    // Model componenet that is set up when view is created. When done button is pressed, it is added to the actual model
    @State private var tallyDatum: TallyDatum = TallyDatum(date: Date(), value: 0)
    
    // Variable that date picker binds to
    @State private var date = Date()
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            // Header at top of view
            HStack {
                // Close button
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
                
                // Done button
                Button(action: {
                    self.tallyDatum.date = TallyDatum.df.string(from: self.date)
                                       
                    // Remove old tallyDatum if editing
                    if self.isEditing {
                        let oldIdx = self.tally.data.firstIndex(where: { $0.id == self.selectedTallyDatumID })!
                        self.tally.data.remove(at: oldIdx)
                    }
                    
                    // Check if there is a tally datum already at date. If so, overwrite it
                    if let idx = self.tally.data.firstIndex(where: { $0.date == self.tallyDatum.date }) {
                        self.tally.data[idx] = self.tallyDatum
                    } else {
                        let idx = self.tally.data.firstIndex(where: { $0.date < self.tallyDatum.date }) ?? self.tally.data.count
                        self.tally.data.insert(self.tallyDatum, at: idx);
                    }
                    
                    self.presenting = false
                    
                }, label: {
                    Text(isEditing ? "Done" : "Add")
                        .font(Font.system(.body, design: .rounded))
                        .bold()
                })
                // Disable done button when the TallyDatum is blank
                .disabled(self.tallyDatum.intValue == 0 && self.tally.kind != .completion)
                .padding([.horizontal, .top])
            }
            
            
            // Editable fields
            
            List {
                
                // Field to set value
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Value")
                            .font(Font.system(.body, design: .rounded))
                        
                        // If the tally is the completion type, show a checkmark. Otherwise, show a text field
                        if self.tally.kind == .completion {
                            Spacer()
                            
                            Button(action: {
                                self.tallyDatum.boolValue.toggle()
                            }) {
                                Image(systemName: self.tallyDatum.boolValue ? "checkmark.circle.fill" : "checkmark.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(self.tallyDatum.boolValue ? .customAccent : Color(UIColor.tertiaryLabel))                            
                            }
                            .padding(.bottom, -2)
                        } else {
                            // Custom numeric text field that only accepts numeric 4-digit or less inputs
                            NumericTextField(placeholder: "0", text: self.$tallyDatum.defaultBlankStringValue)
                        }
                        
                    }
                    
                    // Divider at the bottom of the list cell
                    Divider()
                        .padding(.top, -5)
                        .padding(.trailing, -20)
                }
                .padding(.bottom, -10)

                // Date picker
                VStack {
                    DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                        Text("Date")
                        .font(Font.system(.body, design: .rounded))
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
                self.tallyDatum.date = td.date
                self.tallyDatum.intValue = td.intValue
                self.date = TallyDatum.df.date(from: td.date)!
                self.isEditing = true
            } else {
                self.date = Date()
                self.isEditing = false
            }
        }
        
    }
}










struct EditTallyDatumView_Previews: PreviewProvider {
    static var previews: some View {
        EditTallyDatumView(presenting: .constant(true),
                           tally: Tally(kind: .completion, name: "Test", data: [TallyDatum]()),
                           selectedTallyDatumID: .constant(nil))
    }
}
