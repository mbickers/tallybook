//
//  AuthenticationService.swift
//  Tallybook
//
//  Created by Max Bickers on 12/3/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import Firebase
import Foundation

class AuthenticationService: ObservableObject {
  @Published var user: User? = nil

  init() {
    Auth.auth().addStateDidChangeListener { _, user in
      self.user = user
    }
  }

  func trySignIn(
    withEmail email: String, password: String, completion handler: @escaping AuthDataResultCallback
  ) {
    Auth.auth().signIn(withEmail: email, password: password, completion: handler)
  }

  func trySignUp(
    withEmail email: String, password: String, completion handler: @escaping AuthDataResultCallback
  ) {
    Auth.auth().createUser(withEmail: email, password: password, completion: handler)
  }

  func tryPasswordReset(withEmail email: String, completion handler: @escaping (Error?) -> Void) {
    Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
  }

  func signOut() {
    try! Auth.auth().signOut()
  }
}
