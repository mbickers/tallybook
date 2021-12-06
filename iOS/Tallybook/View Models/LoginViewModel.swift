//
//  LoginViewModel.swift
//  Tallybook
//
//  Created by Max Bickers on 12/6/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Foundation

class LoginViewModel: ObservableObject {
  static private let emailDetector = try! NSDataDetector(
    types: NSTextCheckingResult.CheckingType.link.rawValue)
  private let authenticationService: AuthenticationService = AppDelegate.shared
    .authenticationService
  @Published var alertData: (title: String, message: String)? = nil

  var showingAlert: Bool {
    get {
      return alertData != nil
    }

    set {
      if newValue == false {
        alertData = nil
      }
    }
  }

  func validateEmail(_ email: String) -> Bool {
    let matches = LoginViewModel.emailDetector.matches(
      in: email, options: [], range: NSMakeRange(0, email.count))

    return matches.count == 1 && matches.first!.url!.scheme == "mailto"
  }

  func trySignUp(withEmail email: String, password: String) {
    authenticationService.trySignUp(withEmail: email, password: password) { _, error in
      if let error = error {
        self.alertData = ("Unable to sign up", error.localizedDescription)
      }
    }
  }

  func trySignIn(withEmail email: String, password: String) {
    authenticationService.trySignIn(withEmail: email, password: password) { _, error in
      if let error = error {
        self.alertData = ("Unable to sign in", error.localizedDescription)
      }
    }
  }

  func tryPasswordReset(withEmail email: String) {
    authenticationService.tryPasswordReset(withEmail: email) { error in
      if let error = error {
        self.alertData = ("Unable to reset password", error.localizedDescription)
      } else {
        self.alertData = ("Password reset email sent", "")
      }
    }
  }
}
