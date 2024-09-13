//
//  MainFlowCoordinator.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.04.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import SKAbstractions
import UIKit

final class MainScreenCoordinator: Coordinator<Void, Void> {
  
  // MARK: - Private variables
  
  private let services: IApplicationServices
  private var navigationController: UINavigationController?
  
  private var settingsScreenFlowCoordinator: SettingsScreenFlowCoordinator?
  private var mainScreenModule: MainScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(_ services: IApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  override func start(parameter: Void) {
    Task { @MainActor [weak self] in
      guard let self else { return }
      openMainScreenModule()
    }
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func openSettinsScreen() {
    openSettingsScreenFlowCoordinator()
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func openMainScreenModule() {
    var mainScreenModule = MainScreenAssembly().createModule(services: services)
    mainScreenModule.input.moduleOutput = self
    self.mainScreenModule = mainScreenModule
    let navigationController = mainScreenModule.viewController.wrapToNavigationController()
    self.navigationController = navigationController
    navigationController.presentAsRoot()
  }
  
  func openSettingsScreenFlowCoordinator() {
    let settingsScreenFlowCoordinator = SettingsScreenFlowCoordinator(
      services,
      navigationController: navigationController
    )
    self.settingsScreenFlowCoordinator = settingsScreenFlowCoordinator
    settingsScreenFlowCoordinator.finishFlow = { [weak self] _ in
      self?.settingsScreenFlowCoordinator = nil
    }
    
    settingsScreenFlowCoordinator.start()
  }
}

// MARK: - Private

private extension MainScreenCoordinator {}
