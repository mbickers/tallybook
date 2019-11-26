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
    
    
    @State var fieldValue: String = ""
    
    
    var index: Int {
        userData.tallies.firstIndex(where: { $0.kind == tally.kind })!
    }
    
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
                        VStack {
                            Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(.green)
                            
                            Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(.red)
                        }
                        .padding(.top, -20)
                        
                        Text("23")
                        .font(.system(size: 99, weight: .regular, design: .rounded))
                            .padding(.top, -25)
                    }
                    
                    
                }
                
                if tally.kind == .amount {
                    TextField("Tap", text: $fieldValue)
                        .font(.system(size: 99, weight: .regular, design: .rounded))
                        .padding(.top, -25)
                        .zIndex(200)
                }
                
                
                
            }
            .padding(.leading, 10)
            .scaledToFill()
            
            
            if tally.kind != .amount {
                Spacer()
            }
            
            
            
            ZStack {
                Rectangle()
                    .frame(width: 62)
                    .foregroundColor(.green)
                
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
        .zIndex(-200)
            

        }
        .frame(height: 150)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 3, x: 0, y: 2)
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
    }
}

struct TallyBlock_Previews: PreviewProvider {
    static var previews: some View {
        
        TallyBlock(tally: UserData.testData().tallies[2])
            .environmentObject(UserData.testData())
        
        
    }
}
