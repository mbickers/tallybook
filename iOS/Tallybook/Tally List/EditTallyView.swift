//
//  AddTallyView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/5/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct EditTallyView: View {
  @State var tally: Tally
  let onCommit: (Tally) -> Void
  @State private var animatingTallyBlock = false
  @Environment(\.presentationMode) var presentationMode

  init(tally: Tally, onCommit: @escaping (Tally) -> Void) {
    _tally = State(wrappedValue: tally)
    self.onCommit = onCommit
    let selectedFont = UIFont.systemRounded(style: .callout, weight: .semibold)
    UISegmentedControl.appearance().setTitleTextAttributes([.font: selectedFont], for: .selected)

    let defaultFont = UIFont.systemRounded(style: .callout, weight: .regular)
    UISegmentedControl.appearance().setTitleTextAttributes([.font: defaultFont], for: .normal)
  }

  var body: some View {
    VStack(alignment: .center) {
      HStack {
        Button(
          action: {
            presentationMode.wrappedValue.dismiss()
          },
          label: {
            Text("Cancel")
              .font(Font.system(.body, design: .rounded))
          }
        )
        .padding()

        Spacer()

        Text("New Tally")
          .font(Font.system(.body, design: .rounded))
          .bold()

        Spacer()

        Button(
          action: {
            onCommit(tally)
            presentationMode.wrappedValue.dismiss()
          },
          label: {
            Text("Done")
              .font(Font.system(.body, design: .rounded))
              .bold()
          }
        )
        .padding()
        .disabled(tally.name == "")
      }

      TallyRow(tally: $tally)
        .disabled(true)
        .scaleEffect(animatingTallyBlock ? 0.75 : 0.8)
        .padding(.bottom, 30)
        .onAppear {
          withAnimation(Animation.easeInOut(duration: 1.2).repeatForever()) {
            self.animatingTallyBlock = true
          }
        }

      AutofocusTextField(text: $tally.name)
        // Need to set max frame to .infinity for layout to work correctly
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(UIColor.tertiarySystemFill))
        .cornerRadius(12)
        .padding(.horizontal)

      Picker(selection: $tally.kind, label: Text("Tally Type")) {
        ForEach(Tally.Kind.allCases, id: \.self) { kind in
          Text(kind.rawValue)
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

struct EditTallyView_Previews: PreviewProvider {
  static var previews: some View {
    EditTallyView(
      tally: Tally(name: "Test", kind: .completion), onCommit: { newValue in print(newValue) })
  }
}
