//
//  TallyBlock.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyBlock: View {
    
    @ObservedObject var tally: Tally
    
    // Used to tell whether dark mode is on
    @Environment(\.colorScheme) var colorScheme: ColorScheme    

    
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
                        self.tally.completionToday.toggle()
                    }) {
                        Image(systemName: tally.completionToday ? "checkmark.circle.fill" : "checkmark.circle")
                            .resizable()
                            .frame(width: 84, height: 84)
                            .animation(nil)
                            .foregroundColor(tally.completionToday ? .customAccent : Color(UIColor.tertiaryLabel))                            
                    }
                    .buttonStyle(CheckButtonStyle())
                    .padding(.top, -5)
                }
                
                if tally.kind == .counter {
                    HStack {
                        Button(action: {
                            self.tally.numericToday += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 84, height: 84)
                                .animation(nil)
                                .foregroundColor(.customAccent)
                        }
                        .buttonStyle(CounterButtonStyle())
                        
                        CustomNumericTextField(placeholder: "0", text: $tally.numericStringToday)
                            // Setting max width to .infinity actually stops the text field from expanding and taking up too much space
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                        .padding(.top, -25)
                }
                
                if tally.kind == .amount {
                    CustomNumericTextField(placeholder: "Tap", text: $tally.numericStringToday)
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
                    .foregroundColor(.customAccent)
                
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
            }
        }
        .accentColor(.customAccent)
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
//        List {
//            TallyBlock(tally: $(userData.tallies[0]))
//                .environmentObject(UserData.testData())
//            TallyBlock(tally: UserData.testData().tallies[1])
//                .environmentObject(UserData.testData())
//            TallyBlock(tally: UserData.testData().tallies[3])
//                .environmentObject(UserData.testData())
//        }
        
        
        Group {
            TalliesView()
            
            TalliesView()
                .environment(\.colorScheme, .dark)
        }
        
        
    }
}
