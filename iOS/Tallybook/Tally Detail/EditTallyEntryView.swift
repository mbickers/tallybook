//
//  EditTallyEntryView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/11/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// View to Add/Edit tally entries
struct EditTallyEntryView: View {
  enum Mode: String {
    case edit, add
  }
  let tallyKind: Tally.Kind
  @State var entry: Tally.Entry
  let mode: Mode
  let onCommit: (Tally.Entry) -> Void
  @State private var date = Date()
  @Environment(\.presentationMode) private var presentationMode

  var body: some View {
    NavigationView {
      List {
        VStack {
          HStack(alignment: .firstTextBaseline) {
            Text("Value")
            if tallyKind == .completion {
              Spacer()

              Button {
                entry.boolValue.toggle()
              } label: {
                Image(
                  systemName: "checkmark.circle" + (entry.boolValue ? ".fill" : "")
                )
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(
                  entry.boolValue ? .customAccent : Color(UIColor.tertiaryLabel))
              }
              .padding(.bottom, -2)
            } else {
              NumericTextField(value: $entry.value)
            }
          }
        }

        VStack {
          DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
            .onChange(of: date) { newValue in
              entry.date = Tally.Entry.df.string(from: newValue)
            }
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
            onCommit(entry)
            presentationMode.wrappedValue.dismiss()
          }
        }
      }
      .navigationTitle("\(mode.rawValue.localizedCapitalized) Entry")
      .navigationBarTitleDisplayMode(.inline)
    }
    .accentColor(Color.customAccent)
    .font(Font.system(.body, design: .rounded))
    .onAppear {
      date = Tally.Entry.df.date(from: entry.date)!
    }
  }
}

struct EditTallyEntryView_Previews: PreviewProvider {
  static var previews: some View {
    EditTallyEntryView(
      tallyKind: .amount, entry: Tally.Entry(Date(), value: 3), mode: .edit,
      onCommit: { entry in print(entry) })
  }
}
