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
  private var premiumScreenModule: PremiumScreenModule?
  private var premiumScreenNavigationController: UINavigationController?
  private var imageViewerModule: ImageViewerModule?
  private var secureDataManagerService: ISecureDataManagerService {
    services.dataManagementService.getSecureDataManagerService(.configurationSecrets)
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(_ services: IApplicationServices) {
    self.services = services
    super.init()
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appDidEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
  }
  
  // MARK: - Internal func
  
  override func start(parameter: Void) {
    incrementCounterOnScreenOpen()
    
    Task { @MainActor [weak self] in
      guard let self else { return }
      openMainScreenModule()
    }
  }
  
  // Метод, который будет вызван при переходе в foreground
  @objc 
  func appDidEnterForeground() {
    presentSalePremium()
    incrementCounterOnScreenOpen()
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  @MainActor
  func openImageViewer(image: UIImage?) async {
    openImageViewerSheet(image: image)
  }
  
  @MainActor
  func limitOfAddedCurrenciesHasBeenExceeded() async {
    UIViewController.topController?.showAlertWithTwoButtons(
      title: CurrencifyStrings.Localization
        .Alert.Premium.Offer.title,
      cancelButtonText: CurrencifyStrings.Localization
        .Alert.Premium.Cancel.Button.title,
      customButtonText: CurrencifyStrings.Localization
        .Alert.Premium.Offer.Button.title,
      customButtonAction: { [weak self] in
        self?.openPremiumSaleScreenModule()
      }
    )
  }
  
  func openSettinsScreen() {
    openSettingsScreenFlowCoordinator()
  }
}

// MARK: - PremiumScreenModuleOutput

extension MainScreenCoordinator: PremiumScreenModuleOutput {
  func closeButtonAction() {
    premiumScreenModule?.dismiss(animated: true)
  }
  
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

// MARK: - ImageViewerModuleOutput

extension MainScreenCoordinator: ImageViewerModuleOutput {
  func imageViewerModuleClosed() {
    imageViewerModule?.viewController.dismiss(animated: true)
  }
}

// MARK: - Open modules

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
  
  func openPremiumSaleScreenModule() {
    let premiumScreenModule = PremiumScreenAssembly().createModule(services: services)
    self.premiumScreenModule = premiumScreenModule
    self.premiumScreenModule?.moduleOutput = self
    premiumScreenModule.selectIsModalPresentationStyle(true)
    premiumScreenModule.setLifetimeSale(true)
    
    let premiumScreenNavigationController = UINavigationController(rootViewController: premiumScreenModule)
    self.premiumScreenNavigationController = premiumScreenNavigationController
    premiumScreenNavigationController.modalPresentationStyle = .fullScreen
    navigationController?.present(premiumScreenNavigationController, animated: true)
  }
  
  func openImageViewerSheet(image: UIImage?) {
    var imageViewerModule = ImageViewerAssembly().createModule(image: image, services: services)
    self.imageViewerModule = imageViewerModule
    imageViewerModule.input.moduleOutput = self
    mainScreenModule?.viewController.presentBottomSheet(
      imageViewerModule.viewController,
      detents: [.medium(), .large()]
    )
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func incrementCounterOnScreenOpen() {
    var count = getCounterOnScreenOpen()
    count += 1
    secureDataManagerService.saveString("\(count)", key: Constants.salePremiumKey)
  }
  
  func getCounterOnScreenOpen() -> Int {
    let countString = secureDataManagerService.getString(for: Constants.salePremiumKey) ?? ""
    return Int(countString) ?? .zero
  }
  
  func presentSalePremium() {
    let count = getCounterOnScreenOpen()
    services.appSettingsDataManager.getAppSettingsModel { [weak self] appSettingsModel in
      guard let self, !appSettingsModel.isPremium, count.isMultiple(of: 10) else { return }
      DispatchQueue.main.async { [weak self] in
        self?.openPremiumSaleScreenModule()
      }
    }
  }
  
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
  static let salePremiumKey = "SalePremiumKey"
}
