//
//  TallyBlock.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyBlock: View {
    var tally: Tally
    
    // Used to tell whether dark mode is on
    @Environment(\.colorScheme) var colorScheme: ColorScheme    
    
    // State variable used for both counter and amount tallies
    @State private var fieldValue: String?
    @State private var checkValue: Bool = false
    
    // Here for convenience
    var green = Color(UIColor.systemGreen)
    

    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                
                Text(tally.name)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .padding(.top, 7)
                    .layoutPriority(10)
                
                
                // Interactive component of each tally block
                
                if tally.kind == .completion {
                    Button(action: {
                        self.checkValue.toggle()
                    }) {
                        Image(systemName: checkValue ? "checkmark.circle.fill" : "checkmark.circle")
                            .resizable()
                            .frame(width: 84, height: 84)
                            .animation(nil)
                            .foregroundColor(checkValue ? green : Color(UIColor.tertiaryLabel))
                            
                    }
                    .buttonStyle(CheckButtonStyle())
                    .padding(.top, -5)
                }
                
                if tally.kind == .counter {
                    HStack {
                        Button(action: {
                            //count++
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 84, height: 84)
                                .animation(nil)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(CounterButtonStyle())
                        
                        CustomNumericTextField(placeholder: "0", text: $fieldValue)
                            //.padding(.top, -25)
                            // Setting max width to .infinity actually stops the text field from expanding and taking up too much space
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                        .padding(.top, -25)
                }
                
                if tally.kind == .amount {
                    CustomNumericTextField(placeholder: "Tap", text: $fieldValue)
                        .padding(.top, -25)
                        // Setting max width to .infinity actually stops the text field from expanding and taking up too much space
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
                .padding(.leading, 12)
            
            
            Spacer()
            
            // Button linking to detail view
            ZStack {
                Rectangle()
                    .frame(width: 62)
                    .foregroundColor(green)
                
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
            }
        }
            .accentColor(green)
            .frame(height: 145)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(20)
            // Only have shadows when dark mode is off
            .shadow(color: .gray, radius: colorScheme != .dark ? 3 : 0, x: 0, y: colorScheme != .dark ? 2 : 0)
    }
}

struct CheckButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.07 : 1.0)
    }
}

struct CounterButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.07 : 1.0)
    }
}

struct TallyBlock_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TallyBlock(tally: UserData.testData().tallies[0])
                .environmentObject(UserData.testData())
            TallyBlock(tally: UserData.testData().tallies[1])
                .environmentObject(UserData.testData())
            TallyBlock(tally: UserData.testData().tallies[3])
                .environmentObject(UserData.testData())
        }
        
//        
//        Group {
//            TalliesView()
//                .environmentObject(UserData.testData())
//                .environment(\.colorScheme, .dark)
//            
//            TalliesView()
//                .environmentObject(UserData.testData())
//        }
        
        
    }
}
