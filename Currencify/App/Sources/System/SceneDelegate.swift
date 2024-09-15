//
//  SceneDelegate.swift
//  Currencify
//
//  Created by Vitalii Sosin on 12.04.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKUIKit
import SKAbstractions
import SKServices
import SwiftUI
import BackgroundTasks
import ApphudSDK

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Internal properties
  
  var window: UIWindow?
  
  // MARK: - Private properties
  
  private let services: IApplicationServices = ApplicationServices()
  private var rootCoordinator: RootCoordinator?
  private var firstStart = false
  
  // MARK: - Internal func
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfig.delegateClass = SceneDelegate.self
    return sceneConfig
  }
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = TouchObservingWindow(windowScene: windowScene)
    ConfigurationValueConfigurator(services: services).configure()
    FirstLaunchConfigurator(services: services).configure()
    AppearanceConfigurator(services: services).configure()
    CurrencyRatesConfigurator(services: services).configure()
    Apphud.start(apiKey: Secrets.apiKeyApphud)
    PremiumConfigurator(services: services).configure()
    
    rootCoordinator = RootCoordinator(services)
    rootCoordinator?.start()
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    if firstStart {
      [
        ConfigurationValueConfigurator(services: services),
        PremiumConfigurator(services: services),
        CurrencyRatesConfigurator(services: services)
      ].configure()
    }
    firstStart = true
  }
}

// MARK: - Private

private extension SceneDelegate {}
