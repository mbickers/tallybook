//
//  TallyBlock.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyBlock: View {
    
    @EnvironmentObject var userData: UserData
    var tally: Tally
    
    // Used to tell whether dark mode is on
    @Environment(\.colorScheme) var colorScheme: ColorScheme    
    
    // State variable used for both counter and amount tallies
    @State var fieldValue: String?
    
    // Here for convenience
    var green = Color(UIColor.systemGreen)
    
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(tally.name)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                
                
                // Interactive component of each tally block
                
                if tally.kind == .completion {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 84, height: 84)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .padding(.top, -5)
                }
                
                if tally.kind == .counter {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 84, height: 84)
                            .foregroundColor(green)
                            .padding(.top, -5)
                            .padding(.top, -20)
                        
                        CustomNumericTextField(placeholder: "0", text: $fieldValue)
                            .padding(.top, -25)
                            // Setting max width to .infinity actually stops the text field from expanding and taking up too much space
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                    }
                }
                
                if tally.kind == .amount {
                    CustomNumericTextField(placeholder: "Tap", text: $fieldValue)
                        .padding(.top, -25)
                        // Setting max width to .infinity actually stops the text field from expanding and taking up too much space
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
                .padding(.leading, 10)
            
            
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
            .frame(height: 150)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(20)
            // Only have shadows when dark mode is off
            .shadow(color: .gray, radius: colorScheme != .dark ? 3 : 0, x: 0, y: colorScheme != .dark ? 2 : 0)        
    }
}

struct TallyBlock_Previews: PreviewProvider {
    static var previews: some View {
        
//        TallyBlock(tally: UserData.testData().tallies[1])
//            .environmentObject(UserData.testData())
        
        Group {
            TalliesView()
                .environmentObject(UserData.testData())
                .environment(\.colorScheme, .dark)
            
            TalliesView()
                .environmentObject(UserData.testData())
        }
        
        
    }
}
