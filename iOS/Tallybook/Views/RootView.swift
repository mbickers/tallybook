//
//  RootView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/3/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation
import SwiftUI

struct RootView: View {
  @ObservedObject private var authenticationService = AppDelegate.shared.authenticationService

  var body: some View {
    let showingLoginBinding = Binding {
      return authenticationService.user == nil
    } set: { _ in
    }

    TallyListView()
      .sheet(isPresented: showingLoginBinding) {
        LoginView()
          .interactiveDismissDisabled()
      }
  }
}
