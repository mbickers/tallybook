//
//  LoginView.swift
//  Tallybook
//
//  Created by Max Bickers on 12/3/21.
//  Copyright © 2021 Max Bickers. All rights reserved.
//

import SwiftUI

struct LoginView: View {
  @ObservedObject private var loginViewModel = LoginViewModel()
  @State private var email = ""
  @State private var password = ""

  private func resetPasswordView() -> some View {
    ScrollView {
      TextField("Email", text: $email)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        .textFieldStyle(.roundedBorder)
        .padding(.vertical)

      Button {
        loginViewModel.tryPasswordReset(withEmail: email)
      } label: {
        Text("Send Reset Link")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .disabled(!loginViewModel.validateEmail(email))
    }
    .padding(.horizontal)
    .navigationTitle("Reset Password")
  }

  var body: some View {
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
          NavigationLink("Reset Password") {
            resetPasswordView()
          }
        }

        HStack {
          Button {
            loginViewModel.trySignUp(withEmail: email, password: password)
          } label: {
            Text("Sign Up")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)

          Button {
            loginViewModel.trySignIn(withEmail: email, password: password)
          } label: {
            Text("Sign In")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
        }
        .disabled(!loginViewModel.validateEmail(email) || password.isEmpty)
        .padding(.top)
      }
      .padding(.horizontal)
      .navigationTitle("Sign in to Tallybook")
      .navigationBarTitleDisplayMode(.inline)
      .alert(isPresented: $loginViewModel.showingAlert) {
        Alert(
          title: Text(loginViewModel.alertData!.title),
          message: Text(loginViewModel.alertData!.message))
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
