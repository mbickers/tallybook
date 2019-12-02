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
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    @State var fieldValue: String = ""
    var green = Color(UIColor.systemGreen)
    
    
    var body: some View {
        
                
        HStack {

            VStack(alignment: .leading) {
                
                Text(tally.name)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                
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
                        
                        TextField("0", text: $fieldValue)
                        .font(.system(size: 99, weight: .regular, design: .rounded))
                            .keyboardType(.numberPad)

                            .padding(.top, -25)
                        .zIndex(200)
                        
                    }
                    
                    
                }
                
                if tally.kind == .amount {
                    TextField("Tap", text: $fieldValue)
                        .font(.system(size: 99, weight: .regular, design: .rounded))
                        .keyboardType(.numberPad)

                        .padding(.top, -25)

                        .zIndex(200)
                }
                
                
                
            }
            .padding(.leading, 10)
            .scaledToFill()
            
            
            Spacer()

            
            
            
            ZStack {
                Rectangle()
                    .frame(width: 62)
                    .foregroundColor(green)
                
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
            }
        .zIndex(-200)
            

        }
        .frame(height: 150)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(20)
        // Clumsy way to only have shadows if not dark mode
        .shadow(color: .gray, radius: colorScheme != .dark ? 3 : 0, x: 0, y: colorScheme != .dark ? 2 : 0)

        
        
    
    }
}

struct TallyBlock_Previews: PreviewProvider {
    static var previews: some View {
        
        TallyBlock(tally: UserData.testData().tallies[2])
            .environmentObject(UserData.testData())
        
//        Group {
//            TalliesView()
//                .environmentObject(UserData.testData())
//            .environment(\.colorScheme, .dark)
//            
//            TalliesView()
//            .environmentObject(UserData.testData())
//        }
        
        
    }
}
