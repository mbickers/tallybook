//
//  TallyBlock.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// List rows on main screen that show interactive information about each tally
struct TallyBlock: View {
    
    // Reference to Tally model object passed in by parent view
    @ObservedObject var tally: Tally
    
    // Used to tell whether dark mode is on
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // The navigation link to the next view is manually triggered using this variable because the default SwiftUI Navigation Link button doesn't fit with the app UI
    @State private var showingDetailView: Bool = false
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                
                // Name of the Tally at the top of the TallyBlock
                Text(tally.name != "" ? tally.name : " ")
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .padding(.top, 7)
                
                
                // Interactive component of each tally block
                
                HStack(alignment: .center) {
                    if tally.kind == .completion {
                        Button(action: {
                            UIDevice.vibrate()
                            self.tally.today.boolValue.toggle()
                        }) {
                            Image(systemName: tally.today.boolValue ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 84, height: 84)
                                .animation(nil)
                                .foregroundColor(tally.today.boolValue ? .customAccent : Color(UIColor.tertiaryLabel))                            
                        }
                        // ExpandingButtonStyle is a custom style defined below
                        .buttonStyle(ExpandingButtonStyle())
                        .padding(.top, 18)
                    }
                    
                    if tally.kind == .counter {
                        Button(action: {
                            UIDevice.vibrate()
                            self.tally.today.intValue += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 84, height: 84)
                                .animation(nil)
                                .foregroundColor(.customAccent)
                        }
                        .buttonStyle(ExpandingButtonStyle())
                    }
                    
                    if tally.kind != .completion {
                        NumericTallyTextField(placeholder: "0", text: $tally.today.defaultBlankStringValue)
                        // Setting max width to .infinity stops the text field from expanding and taking up too much space
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                .padding(.top, -25)
                
            }
            .padding(.leading, 12)
            
            
            Spacer()
            
            // Navigation button on right side of the tally block
            ZStack {
                // SwiftUI navigation links are a very funky, particular kind of beast.
                // The navigation link button is hidden under other stuff here and minimized, so that its default button doesn't show up
                // It is activated by the showingDetailView binding
                NavigationLink(destination: TallyDetailView(tally: tally), isActive: $showingDetailView) {
                    EmptyView()
                }
                // Disable the button that would show up, not the navigation functionality
                .disabled(true)
                .padding(.all, 0)
                .frame(minWidth: 0, idealWidth: 0, maxWidth: 0, minHeight: 0, idealHeight: 0, maxHeight: 0)
                
                // Green background
                Rectangle()
                    .frame(width: 62)
                    .foregroundColor(.customAccent)
                
                // Chevron icon
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
            }
            .onTapGesture {
                // Activate the navigation link
                self.showingDetailView = true
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

// Custom button style that causes button to expand
struct ExpandingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.07 : 1.0)
    }
}








struct TallyBlock_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TalliesView()
            .environmentObject(UserData.testData)
            
            TalliesView()
                .environmentObject(UserData.testData)
                .environment(\.colorScheme, .dark)
        }
    }
}
