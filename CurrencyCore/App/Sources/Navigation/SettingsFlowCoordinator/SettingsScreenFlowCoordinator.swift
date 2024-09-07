//
//  SettingsScreenFlowCoordinator.swift
//  CurrencyCore
//
//  Created by Vitalii Sosin on 17.04.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import SKAbstractions
import UIKit

final class SettingsScreenFlowCoordinator: Coordinator<Void, SettingsScreenFinishFlowType> {
  
  // MARK: - Private variables
  
  private let services: IApplicationServices
  
  private var settingsScreenModule: SettingsScreenModule?
  private var appearanceAppScreenModule: AppearanceAppScreenModule?
  private var navigationController: UINavigationController?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  ///   - navigationController: Навигейшен контроллер
  init(_ services: IApplicationServices,
       navigationController: UINavigationController?) {
    self.services = services
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  override func start(parameter: Void) {
    openSettingsScreenModule()
  }
}

// MARK: - MainScreenModuleOutput

extension SettingsScreenFlowCoordinator: SettingsScreenModuleOutput {
  func userIntentionExit() {
    Task { @MainActor [weak self] in
      guard let self else { return }
      finishSettingsScreenFlow(.lockCurrencyCore)
    }
  }
  
  func userIntentionDeleteAndExit() {
    let title = CurrencyCoreStrings.SettingsScreenFlowCoordinatorLocalization
      .Notification.IntentionDeleteAndExit.title
    UIViewController.topController?.showAlertWithTwoButtons(
      title: "\(title)?",
      cancelButtonText: CurrencyCoreStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.CancelButton.title,
      customButtonText: CurrencyCoreStrings.SettingsScreenFlowCoordinatorLocalization
        .Notification.DeleteAndExit.title,
      customButtonAction: { [weak self] in
        Task { @MainActor [weak self] in
          guard let self else { return }
          await settingsScreenModule?.input.deleteAllData()
          finishSettingsScreenFlow(.exit)
        }
      }
    )
  }
  
  func openAppearanceSection() {
    openAppearanceAppScreenModule()
  }
  
  func openLanguageSection() {
    UIViewController.topController?.showAlertWithTwoButtons(
      title: CurrencyCoreStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.title,
      cancelButtonText: CurrencyCoreStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.CancelButton.title,
      customButtonText: CurrencyCoreStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.CustomButton.title,
      customButtonAction: { [weak self] in
        Task { [weak self] in
          await self?.services.userInterfaceAndExperienceService.systemService.openSettings()
        }
      }
    )
  }
}

// MARK: - AppearanceAppScreenModuleOutput

extension SettingsScreenFlowCoordinator: AppearanceAppScreenModuleOutput {}

// MARK: - Open modules

private extension SettingsScreenFlowCoordinator {
  func openSettingsScreenModule() {
    var settingsScreenModule = SettingsScreenAssembly().createModule(services)
    self.settingsScreenModule = settingsScreenModule
    settingsScreenModule.input.moduleOutput = self
    navigationController?.pushViewController(settingsScreenModule.viewController, animated: true)
  }
  
  func openAppearanceAppScreenModule() {
    var appearanceAppScreenModule = AppearanceAppScreenAssembly().createModule(services)
    self.appearanceAppScreenModule = appearanceAppScreenModule
    appearanceAppScreenModule.input.moduleOutput = self
    appearanceAppScreenModule.viewController.hidesBottomBarWhenPushed = true
    
    navigationController?.pushViewController(
      appearanceAppScreenModule.viewController,
      animated: true
    )
  }
}

// MARK: - Private

private extension SettingsScreenFlowCoordinator {
  func finishSettingsScreenFlow(_ flowType: SettingsScreenFinishFlowType) {
    settingsScreenModule = nil
    appearanceAppScreenModule = nil
    finishFlow?(flowType)
  }
}
