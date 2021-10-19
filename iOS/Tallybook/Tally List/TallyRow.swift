//
//  TallyBlock.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// List rows on main screen that show interactive information about each tally
struct TallyRow: View {
  @Binding var tally: Tally
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @State private var showingDetailView: Bool = false

  var body: some View {

    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(tally.name.isEmpty ? " " : tally.name)
          .font(.system(size: 22, weight: .regular, design: .rounded))

        Spacer()

        switch tally.kind {
        case .completion:
          Button(action: {
            UIDevice.vibrate()
            withAnimation {
              tally.today.value = tally.today.value < 1 ? 1 : 0
            }
          }) {
            Image(systemName: "checkmark.circle" + (tally.today.value >= 1 ? ".fill" : ""))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundColor(
                tally.today.value >= 1 ? .customAccent : Color(UIColor.tertiaryLabel))
          }
          .buttonStyle(ExpandingButtonStyle())

        case .counter:
          HStack {
            Button(action: {
              UIDevice.vibrate()
              tally.today.value += 1
            }) {
              Image(systemName: "plus.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.customAccent)
            }
            .buttonStyle(ExpandingButtonStyle())

            NumericTallyTextField(value: $tally.today.value)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
          }

        case .amount:
          NumericTallyTextField(value: $tally.today.value)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
        }
      }
      .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 6))

      Spacer()

      ZStack {
        // SwiftUI navigation links are funky and annoying.
        NavigationLink(destination: TallyDetailView(tally: $tally), isActive: $showingDetailView) {
          EmptyView()
        }
        // Disable the default button that shows up
        .disabled(true)
        .padding(.all, 0)
        .frame(minWidth: 0, idealWidth: 0, maxWidth: 0, minHeight: 0, idealHeight: 0, maxHeight: 0)

        Rectangle()
          .frame(width: 62)
          .foregroundColor(.customAccent)

        Image(systemName: "chevron.right.circle.fill")
          .resizable()
          .frame(width: 50, height: 50)
          .foregroundColor(Color(UIColor.tertiarySystemBackground))
      }
      .onTapGesture {
        self.showingDetailView = true
      }
    }
    .frame(height: 145)
    .background(Color(UIColor.tertiarySystemBackground))
    .cornerRadius(20)
    .shadow(color: colorScheme != .dark ? .gray : .black, radius: 3, x: 0, y: 2)
    .listRowSeparator(.hidden)
  }

}

struct ExpandingButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 1.07 : 1.0)
  }
}

struct TallyBlock_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      TallyRow(tally: .constant(Tally(name: "Test", kind: .completion)))
      TallyRow(tally: .constant(Tally(name: "", kind: .completion)))
    }
  }
}
