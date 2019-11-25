//
//  TallyBlock.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct TallyBlock: View {
    
    
    var body: some View {
                
        HStack {

            VStack(alignment: .leading) {
                Text("Cups of Coffee")
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                
                
                Text("729")
                    .font(.system(size: 99, weight: .regular, design: .rounded))
                    .padding(.top, -25)
                
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
        
        TallyBlock()
            .background(Color(UIColor.secondarySystemBackground))
        
        
    }
}
