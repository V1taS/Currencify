//
//  SettingsScreenFlowCoordinator.swift
//  Currencify
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
  private var mailComposeModule: MailComposeModule?
  private var premiumScreenModule: PremiumScreenModule?
  
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
  func userSelectPremium() {
    openPremiumScreenModule()
  }
  
  func userSelectFeedBack() {
    openMailModule()
  }
  
  func userIntentionExit() {
    Task { @MainActor [weak self] in
      guard let self else { return }
      finishSettingsScreenFlow(.lockCurrencify)
    }
  }
  
  func userIntentionDeleteAndExit() {
    let title = CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
      .Notification.IntentionDeleteAndExit.title
    UIViewController.topController?.showAlertWithTwoButtons(
      title: "\(title)?",
      cancelButtonText: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.CancelButton.title,
      customButtonText: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
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
      title: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.title,
      cancelButtonText: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
        .LanguageSection.Alert.CancelButton.title,
      customButtonText: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
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

// MARK: - PremiumScreenModuleOutput

extension SettingsScreenFlowCoordinator: PremiumScreenModuleOutput {
  func closeButtonAction() {}
  func didReceiveRestoredSuccess() {
    setIsPremiumSuccess()
  }
  
  func didReceiveSubscriptionPurchaseSuccess() {
    setIsPremiumSuccess()
  }
  
  func didReceiveOneTimePurchaseSuccess() {
    setIsPremiumSuccess()
  }
  
  func somethingWentWrong() {
    services.userInterfaceAndExperienceService
      .notificationService.showNotification(
        .positive(
          title: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
            .Notification.SomethingWentWrong.title
        )
      )
  }
  
  func didReceivePurchasesMissing() {
    services.userInterfaceAndExperienceService
      .notificationService.showNotification(
        .positive(
          title: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
            .Notification.PurchasesMissing.title
        )
      )
  }
}

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
  
  func openMailModule() {
    let mailComposeModule = MailComposeModule(services)
    self.mailComposeModule = mailComposeModule
    
    guard mailComposeModule.canSendMail() else {
      services.userInterfaceAndExperienceService
        .notificationService.showNotification(
          .negative(
            title: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
              .Notification.MailClientNotFound.title
          )
        )
      return
    }
    
    mailComposeModule.start(completion: { [weak self] in
      self?.mailComposeModule = nil
    })
  }
  
  func openPremiumScreenModule() {
    let premiumScreenModule = PremiumScreenAssembly().createModule(services: services)
    self.premiumScreenModule = premiumScreenModule
    self.premiumScreenModule?.moduleOutput = self
    premiumScreenModule.selectIsModalPresentationStyle(false)
    navigationController?.pushViewController(
      premiumScreenModule,
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
  
  func setIsPremiumSuccess() {
    services.appSettingsDataManager.setIsPremiumEnabled(
      true,
      completion: { [weak self] in
        guard let self else { return }
        services.userInterfaceAndExperienceService
          .notificationService.showNotification(
            .positive(
              title: CurrencifyStrings.SettingsScreenFlowCoordinatorLocalization
                .Notification.PremiumSuccess.title
            )
          )
      }
    )
  }
}
