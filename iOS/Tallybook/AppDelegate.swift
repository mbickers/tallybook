//
//  AppDelegate.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var repository: Repository!
  var authenticationService: AuthenticationService!

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    repository = FirestoreRepository()
    authenticationService = AuthenticationService()

    customizeAppearances()

    return true
  }

  private func customizeAppearances() {
    let selectedFont = UIFont.systemRounded(style: .callout, weight: .semibold)
    UISegmentedControl.appearance().setTitleTextAttributes([.font: selectedFont], for: .selected)

    let defaultFont = UIFont.systemRounded(style: .callout, weight: .regular)
    UISegmentedControl.appearance().setTitleTextAttributes([.font: defaultFont], for: .normal)

    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: UIFont.systemRounded(style: .largeTitle, weight: .bold)
    ]

    UINavigationBar.appearance().titleTextAttributes = [
      .font: UIFont.systemRounded(style: .headline, weight: .semibold)
    ]

    UIDatePicker.appearance().tintColor = UIColor.customAccent
  }

  func application(
    _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(
      name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {}

  static var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
}
