//
//  SceneDelegate.swift
//  Tallybook
//
//  Created by Max Bickers on 11/24/19.
//  Copyright © 2019 Max Bickers. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var userData: UserData!

  func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    if let savedData = UserDefaults.standard.object(forKey: "Data") as? Data,
      let decodedData = try? JSONDecoder().decode(UserData.self, from: savedData)
    {
      userData = decodedData
    } else {
      userData = UserData()
    }

    let contentView = TalliesView()
      .environmentObject(userData)

    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    if let encoded = try? JSONEncoder().encode(userData) {
      UserDefaults.standard.set(encoded, forKey: "Data")
    }
  }
}
