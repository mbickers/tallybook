//
//  EditTallyDatumView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/11/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI

// View to Add/Edit Tally Datums
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
        .padding([.horizontal, .top])

        Spacer()

        Text("\(mode.rawValue.localizedCapitalized) Entry")
          .font(Font.system(.body, design: .rounded))
          .bold()
          .padding(.top)

        Spacer()

        Button(
          action: {
            onCommit(entry)
            presentationMode.wrappedValue.dismiss()
          },
          label: {
            Text(mode == .edit ? "Done" : "Add")
              .font(Font.system(.body, design: .rounded))
              .bold()
          }
        )
        .padding([.horizontal, .top])
      }

      List {
        VStack {
          HStack(alignment: .firstTextBaseline) {
            Text("Value")
              .font(Font.system(.body, design: .rounded))
            if tallyKind == .completion {
              Spacer()

              Button(action: {
                entry.value = 1 - entry.value
              }) {
                Image(
                  systemName: entry.value != 0
                    ? "checkmark.circle.fill" : "checkmark.circle"
                )
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(
                  entry.value != 0 ? .customAccent : Color(UIColor.tertiaryLabel))
              }
              .padding(.bottom, -2)
            } else {
              NumericTextField(value: $entry.value)
            }
          }
        }

        VStack {
          DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
            Text("Date")
              .font(Font.system(.body, design: .rounded))
          }
          .datePickerStyle(WheelDatePickerStyle())
          .onChange(of: date) { newValue in
            entry.date = Tally.Entry.df.string(from: newValue)
          }
        }

      }
      .listStyle(GroupedListStyle())
    }
    .accentColor(Color.customAccent)
    .onAppear {
      date = Tally.Entry.df.date(from: entry.date)!
    }
  }
}

struct EditTallyDatumView_Previews: PreviewProvider {
  static var previews: some View {
    EditTallyEntryView(
      tallyKind: .amount, entry: Tally.Entry(Date(), value: 3), mode: .edit,
      onCommit: { entry in print(entry) })
  }
}
