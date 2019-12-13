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
    
    @State var isEditing: Bool = false
    
    @State var valueString: String = "0"
    @State var valueBool: Bool = true
    
    @State private var date = Date()
    
    init(presenting: Binding<Bool>, tally: Tally, selectedTallyDatumID: Binding<UUID?>) {
        _presenting = presenting
        self.tally = tally
        _selectedTallyDatumID = selectedTallyDatumID
        
        
    }
    
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
                    var value: Int!
                    
                    if self.tally.kind == .completion {
                        value = self.valueBool ? 1 : 0
                    } else {
                        value = Int(self.valueString) ?? 0
                    }
                    
                    let dateString = TallyDatum.df.string(from: self.date)
                    let td = TallyDatum(date: dateString, value: value)
                                       
                    // Remove old tallyDatum if editing
                    if self.isEditing {
                        let oldIdx = self.tally.data.firstIndex(where: { $0.id == self.selectedTallyDatumID })!
                        self.tally.data.remove(at: oldIdx)
                    }
                    
                    // Check if there is a tally datum already at date. If so, overwrite it
                    if let idx = self.tally.data.firstIndex(where: { $0.date == dateString }) {
                        self.tally.data[idx] = td
                    } else {
                        let idx = self.tally.data.firstIndex(where: { $0.date < dateString }) ?? self.tally.data.count
                        self.tally.data.insert(td, at: idx);
                    }
                    
                    
                    self.presenting = false
                }, label: {
                    Text(isEditing ? "Done" : "Add")
                        .font(Font.system(.body, design: .rounded))
                        .bold()
                })
                    .disabled(self.valueString == "" ? true : false)
                    .padding([.horizontal, .top])
            }
            
            
            // Edit fields
            
            List {
                
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Value")
                            .font(Font.system(.body, design: .rounded))
                        
                        if self.tally.kind == .completion {
                            Spacer()
                            
                            Button(action: {
                                self.valueBool.toggle()
                            }) {
                                Image(systemName: self.valueBool ? "checkmark.circle.fill" : "checkmark.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(self.valueBool ? .customAccent : Color(UIColor.tertiaryLabel))                            
                            }
                            .padding(.bottom, -2)
                        } else {
                            TextField("0", text: self.$valueString)
                            .font(Font.system(.body, design: .rounded))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        }
                        
                    }
                    
                    Divider()
                        .padding(.top, -5)
                        .padding(.trailing, -20)
                }
                .padding(.bottom, -10)

                
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
                self.valueString = String(td.value)
                self.valueBool = td.value >= 1
                self.date = TallyDatum.df.date(from: td.date)!
                self.isEditing = true
            } else {
                self.valueString = ""
                self.valueBool = true
                self.date = Date()
                self.isEditing = false
            }
            
            // If the tally kind is completion, the user can exit the edit at any time, so set valueString to something that isn't ""
            if self.tally.kind == .completion {
                self.valueString = "Placeholder"
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
