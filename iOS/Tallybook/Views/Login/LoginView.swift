//
//  LoginView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/3/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import SwiftUI

struct LoginView: View {
  @ObservedObject private var authenticationService = AppDelegate.shared.authenticationService
  @State private var email = ""
  @State private var password = ""
  private struct AlertData {
    let title: String
    let message: String
  }
  @State private var alertData: AlertData? = nil

  private func resetPasswordView() -> some View {
    ScrollView {
      TextField("Email", text: $email)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        .textFieldStyle(.roundedBorder)
        .padding(.vertical)

      Button {
        authenticationService.tryPasswordReset(withEmail: email) { error in
          if let error = error {
            alertData = AlertData(
              title: "Unable to reset password", message: error.localizedDescription)
          } else {
            alertData = AlertData(title: "Password reset link sent", message: "")
          }
        }
      } label: {
        Text("Send password reset link")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .disabled(!email.isValidEmail)
    }
    .padding(.horizontal)
    .navigationTitle("Reset password")
  }

  var body: some View {
    let showingAlertBinding = Binding {
      return self.alertData != nil
    } set: { _, _ in
      self.alertData = nil
    }

    NavigationView {
      ScrollView {
        TextField("Email", text: $email)
          .autocapitalization(.none)
          .keyboardType(.emailAddress)
          .textFieldStyle(.roundedBorder)
          .padding(.top)

        SecureField("Password", text: $password)
          .textFieldStyle(.roundedBorder)
        HStack {
          Spacer()
          NavigationLink("Reset password") {
            resetPasswordView()
          }
        }

        HStack {
          Button {
            authenticationService.trySignUp(withEmail: email, password: password) { _, error in
              if let error = error {
                alertData = AlertData(
                  title: "Unable to sign up", message: error.localizedDescription)
              }
            }
          } label: {
            Text("Sign up")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)

          Button {
            authenticationService.trySignIn(withEmail: email, password: password) { _, error in
              if let error = error {
                alertData = AlertData(
                  title: "Unable to sign in", message: error.localizedDescription)
              }
            }
          } label: {
            Text("Sign in")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
        }
        .disabled(!email.isValidEmail || password.isEmpty)
        .padding(.top)
      }
      .padding(.horizontal)
      .navigationTitle("Log in")
      .navigationBarTitleDisplayMode(.inline)
      .alert(isPresented: showingAlertBinding) {
        Alert(title: Text(alertData!.title), message: Text(alertData!.message))
      }
    }
    .accentColor(.customAccent)
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
