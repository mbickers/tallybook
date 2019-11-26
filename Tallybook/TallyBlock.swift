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
    @State var test: Bool = true
    var tally: Tally
    
    var index: Int {
        userData.tallies.firstIndex(where: { $0.kind == tally.kind })!
    }
    
    var body: some View {
                
        HStack {

            VStack(alignment: .leading) {
                Text("Cups of Coffee")
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                
                if tally.kind == .completion {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 84, height: 84)
                        .foregroundColor(.gray)
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
                    Text("2")
                    .font(.system(size: 99, weight: .regular, design: .rounded))
                    .padding(.top, -25)
                }
                
                
                
            }
            .padding(.leading, 10)
            .scaledToFill()
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: 62)
                    .foregroundColor(.green)
                
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }

        }
        .frame(height: 150)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 3, x: 0, y: 2)
    
        
        
    }
}

struct TallyBlock_Previews: PreviewProvider {
    static var previews: some View {
        
        TallyBlock(tally: Tally(kind: .completion))
            .environmentObject(UserData())
        
        
    }
}
