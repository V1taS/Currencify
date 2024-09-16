//
//  SettingsScreenFlowCoordinator.swift
//  Currencify
//
//  Created by Vitalii Sosin on 17.04.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import SKAbstractions
import UIKit

final class SettingsScreenFlowCoordinator: Coordinator<Void, Void> {
  
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
  func shareButtonSelected() {
    openShareApp()
  }
  
  func userSelectPremium() {
    openPremiumScreenModule()
  }
  
  func userSelectFeedBack() {
    openMailModule()
  }
  
  func openAppearanceSection() {
    openAppearanceAppScreenModule()
  }
  
  func openLanguageSection() {
    UIViewController.topController?.showAlertWithTwoButtons(
      title: CurrencifyStrings.Localization
        .LanguageSection.Alert.title,
      cancelButtonText: CurrencifyStrings.Localization
        .LanguageSection.Alert.CancelButton.title,
      customButtonText: CurrencifyStrings.Localization
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
          title: CurrencifyStrings.Localization
            .Notification.SomethingWentWrong.title
        )
      )
  }
  
  func didReceivePurchasesMissing() {
    services.userInterfaceAndExperienceService
      .notificationService.showNotification(
        .positive(
          title: CurrencifyStrings.Localization
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
            title: CurrencifyStrings.Localization
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
  
  func openShareApp() {
    guard let url = Constants.shareAppUrl else {
      return
    }
    
    let objectsToShare = [url]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      if let popup = activityVC.popoverPresentationController {
        popup.sourceView = settingsScreenModule?.viewController.view
        popup.sourceRect = CGRect(
          x: (settingsScreenModule?.viewController.view.frame.size.width ?? .zero) / 2,
          y: (settingsScreenModule?.viewController.view.frame.size.height ?? .zero) / 4,
          width: .zero,
          height: .zero
        )
      }
    }
    
    settingsScreenModule?.viewController.present(activityVC, animated: true, completion: nil)
  }
}

// MARK: - Private

private extension SettingsScreenFlowCoordinator {
  func setIsPremiumSuccess() {
    services.appSettingsDataManager.setIsPremiumEnabled(
      true,
      completion: { [weak self] in
        guard let self else { return }
        services.userInterfaceAndExperienceService
          .notificationService.showNotification(
            .positive(
              title: CurrencifyStrings.Localization
                .Notification.PremiumSuccess.title
            )
          )
      }
    )
  }
}

// MARK: - Constants

private enum Constants {
  static let shareAppUrl = URL(string: "https://apps.apple.com/app/currencify/id6680185806")
}
