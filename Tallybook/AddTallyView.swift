//
//  AddTallyView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/5/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct AddTallyView: View {
    
    @EnvironmentObject var userData: UserData
    @ObservedObject var tally = Tally(kind: .completion, name: "", data: [TallyDatum]())
    @Binding var presenting: Bool
    
    @State private var animatingTallyBlock = false
    
    
    init(presenting: Binding<Bool>) {
        
        // Need to have a binding to presenting view's "modal show" variable for the done and cancel buttons to work
        _presenting = presenting
        
        // Change font of Segmented Control to rounded. Not possible in native SwiftUI yet
        let selectedFont = UIFont.systemRounded(style: .callout, weight: .semibold)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: selectedFont], for: .selected)
        
        let defaultFont = UIFont.systemRounded(style: .callout, weight: .regular)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: defaultFont], for: .normal)
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            // Header at top of view
            HStack {
                Button(action: {
                    self.presenting = false
                }, label: {
                    Text("Cancel")
                        .font(Font.system(.body, design: .rounded))
                })
                    .padding()
                
                Spacer()
                
                Text("New Tally")
                    .font(Font.system(.body, design: .rounded))
                    .bold()
                    
                
                Spacer()
                
                Button(action: {
                    self.userData.tallies.insert(self.tally, at: 0)
                    self.presenting = false
                }, label: {
                    Text("Done")
                        .font(Font.system(.body, design: .rounded))
                })
                    .padding()
                    // Disable done button whenever there is no text in textfield
                    .disabled(tally.name == "" ? true : false)
            }
            
            // Bouncing preview Tally Block in the middle of the view
            TallyBlock(tally: tally)
                .disabled(true)
                .scaleEffect(animatingTallyBlock ? 0.75 : 0.8)
                .padding(.bottom, 30)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.2).repeatForever()) {
                        self.animatingTallyBlock = true
                    }
                }
            
            CustomAutofocusTextField(text: $tally.name)
                // Need to set max frame to .infinity for layout to work correctly
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(UIColor.tertiarySystemFill))
                .cornerRadius(12)
                .padding(.horizontal)
            
            Picker(selection: $tally.kind, label: Text("Tally Type")) {
                ForEach(Tally.Kind.allCases, id: \.self) { kind in
                    Text(kind.rawValue).tag(Tally.Kind.completion)
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 5)
            
            Spacer()
        }
        .accentColor(Color.customAccent)
        
    }
}

struct AddTallyView_Previews: PreviewProvider {
    static var previews: some View {
        AddTallyView(presenting: .constant(true))
    }
}
