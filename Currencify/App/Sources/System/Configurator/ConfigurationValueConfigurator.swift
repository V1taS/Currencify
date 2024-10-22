//
//  ConfigurationValueConfigurator.swift
//  Currencify
//
//  Created by Vitalii Sosin on 08.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions
import ApphudSDK

final class ConfigurationValueConfigurator: Configurator {
  
  // MARK: - Private properties
  
  private let services: IApplicationServices
  private lazy var cloudKitService: ICloudKitService = services.dataManagementService.cloudKitService
  private lazy var secureDataManagerService = services.dataManagementService.getSecureDataManagerService(.configurationSecrets)
  
  // MARK: - Init
  
  init(services: IApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func configure() {
    let isReachable = services.accessAndSecurityManagementService.networkReachabilityService?.isReachable ?? false
    guard isReachable else { return }
    
    Task {
      await getApiKeyApphud()
      await getSupportOChatMail()
      await getPremiumList()
    }
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  func getApiKeyApphud() async {
    if let value = await getConfigurationValue(forKey: Constants.apiKeyApphud) {
      DispatchQueue.main.async {
        Apphud.start(apiKey: value)
      }
    }
  }
  
  func getSupportOChatMail() async {
    if let value = await getConfigurationValue(forKey: Constants.supportOChatMail) {
      Secrets.supportMail = value
    }
  }
  
  func getPremiumList() async {
    if let value = await getConfigurationValue(forKey: Constants.premiumList) {
      guard let jsonData = value.data(using: .utf8) else {
        return
      }
      let premiumList = PremiumModel.decodeFromJSON(jsonData)
      await setPremium(premiumList: premiumList)
    }
  }
  
  func getConfigurationValue(forKey key: String) async -> String? {
    await withCheckedContinuation { continuation in
      cloudKitService.getConfigurationValue(from: key) { (result: Result<String?, Error>) in
        if case let .success(value) = result, let value {
          continuation.resume(returning: value)
        } else {
          continuation.resume(returning: nil)
        }
      }
    }
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  func setPremium(premiumList: [PremiumModel]) async {
    let checkIsPremium = await checkIsPremium()
    let isPremium = manualIsPremiumCheck(premiumList) || checkIsPremium
    await setIsPremiumEnabled(isPremium)
  }
    
    func setIsPremiumEnabled(_ isPremium: Bool) async {
      await withCheckedContinuation { continuation in
        services.appSettingsDataManager.setIsPremiumEnabled(isPremium) {
          continuation.resume()
        }
      }
    }
  
  func manualIsPremiumCheck(_ premiumList: [PremiumModel]) -> Bool {
    let systemService = services.userInterfaceAndExperienceService.systemService
    let vendorID = systemService.getDeviceIdentifier()
    let user = premiumList.first(where: { $0.id == vendorID })
    print("✅ vendorID: \(vendorID)")
    return user?.isPremium ?? false
  }
  
  func checkIsPremium() async -> Bool {
    await withCheckedContinuation { continuation in
      services.appPurchasesService.isValidatePurchase { isValidate in
        continuation.resume(returning: isValidate)
      }
    }
  }
}

// MARK: - Constants

private enum Constants {
  static let supportOChatMail = "SupportOChatMail"
  static let premiumList = "PremiumList"
  static let apiKeyApphud = "ApiKeyApphud"
  
  static let oneDayPassKey = "OneDayPassKey"
}
