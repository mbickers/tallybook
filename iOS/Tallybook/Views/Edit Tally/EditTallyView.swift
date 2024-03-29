//
//  EditTallyView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/5/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

struct EditTallyView: View {
  enum Mode: String {
    case edit, add
  }
  let mode: Mode
  @State var tally: Tally
  let onCommit: (Tally) -> Void
  @State private var animatingTallyBlock = false
  @Environment(\.presentationMode) private var presentationMode

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .center) {
          TallyRow(viewModel: TallyRowViewModel(tally: tally))
            .disabled(true)
            .scaleEffect(animatingTallyBlock ? 0.75 : 0.8)
            .animation(.easeInOut(duration: 1.2).repeatForever(), value: animatingTallyBlock)
            .onAppear {
              animatingTallyBlock = true
            }
            .padding(.bottom, 30)

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
          .padding(.top, 5)
          .padding(.horizontal)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(mode == .edit ? "Done" : "Add") {
            onCommit(tally)
            presentationMode.wrappedValue.dismiss()
          }
          .disabled(tally.name.isEmpty)
        }
      }
      .navigationTitle("\(mode.rawValue.localizedCapitalized) Tally")
      .navigationBarTitleDisplayMode(.inline)
    }
    .font(Font.system(.body, design: .rounded))
    .accentColor(Color.customAccent)
  }
}

struct EditTallyView_Previews: PreviewProvider {
  static var previews: some View {
    EditTallyView(mode: .add, tally: Tally()) { tally in
      print(tally)
    }
  }
}
