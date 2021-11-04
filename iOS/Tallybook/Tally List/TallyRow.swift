//
//  TallyRow.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// List rows on main screen that show interactive information about each tally
struct TallyRow: View {
  @ObservedObject var viewModel: TallyRowViewModel
  @Environment(\.colorScheme) private var colorScheme: ColorScheme
  @State private var showingDetailView: Bool = false

  var body: some View {

    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(viewModel.tally.name.isEmpty ? " " : viewModel.tally.name)
          .font(.system(size: 22, weight: .regular, design: .rounded))

        Spacer()

        switch viewModel.tally.kind {
        case .completion:
          Button {
            UIDevice.vibrate()
            withAnimation {
              viewModel.tally.today.boolValue.toggle()
            }
          } label: {
            Image(systemName: "checkmark.circle" + (viewModel.tally.today.boolValue ? ".fill" : ""))
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundColor(
                viewModel.tally.today.boolValue ? .customAccent : Color(UIColor.tertiaryLabel))
          }
          .buttonStyle(ExpandingButtonStyle())

        case .counter:
          HStack {
            Button {
              UIDevice.vibrate()
              viewModel.tally.today.value += 1
            } label: {
              Image(systemName: "plus.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.customAccent)
            }
            .buttonStyle(ExpandingButtonStyle())

            NumericTallyTextField(value: $viewModel.tally.today.value)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
          }

        case .amount:
          NumericTallyTextField(value: $viewModel.tally.today.value)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
        }
      }
      .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 6))

      Spacer()

      ZStack {
        // SwiftUI navigation links are funky and annoying.
        NavigationLink(
          destination: TallyDetailView(tally: $viewModel.tally), isActive: $showingDetailView
        ) {
          EmptyView()
        }
        // Disable the default button that shows up
        .disabled(true)
        .frame(width: 0, height: 0)

        Rectangle()
          .frame(width: 62)
          .foregroundColor(.customAccent)

        Image(systemName: "chevron.right.circle.fill")
          .resizable()
          .frame(width: 50, height: 50)
          .foregroundColor(Color(UIColor.tertiarySystemBackground))
      }
      .onTapGesture {
        showingDetailView = true
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

struct TallyRow_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      TallyRow(viewModel: TallyRowViewModel(tally: Tally(name: "Test", kind: .completion)))
      TallyRow(viewModel: TallyRowViewModel(tally: Tally(name: "", kind: .completion)))
    }
  }
}
