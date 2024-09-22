//
//  ConfigurationValueConfigurator.swift
//  Currencify
//
//  Created by Vitalii Sosin on 08.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

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
    getApiKeyApphud()
    getSupportOChatMail()
    getPremiumList()
    getIsPremiumMode()
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  func getIsPremiumMode() {
    if let value = getConfigurationValue(forKey: Constants.isPremiumMode) {
      Secrets.isPremiumMode = Bool(value) ?? true
    }
  }
  
  func getApiKeyApphud() {
    if let value = getConfigurationValue(forKey: Constants.apiKeyApphud) {
      Secrets.apiKeyApphud = value
    }
  }
  
  func getSupportOChatMail() {
    if let value = getConfigurationValue(forKey: Constants.supportOChatMail) {
      Secrets.supportMail = value
    }
  }
  
  func getPremiumList() {
    if let value = getConfigurationValue(forKey: Constants.premiumList) {
      guard let jsonData = value.data(using: .utf8) else {
        return
      }
      let premiumList = PremiumModel.decodeFromJSON(jsonData)
      Secrets.premiumList = premiumList
    }
  }
  
  func getConfigurationValue(forKey key: String) -> String? {
    if let value = secureDataManagerService.getString(for: key), !isMoreThan15MinutesPassed() {
      return value
    }
    
    let semaphore = DispatchSemaphore(value: .zero)
    var retrievedValue: String?
    
    cloudKitService.getConfigurationValue(from: key) { [weak self] (result: Result<String?, Error>) in
      if case let .success(value) = result, let value {
        retrievedValue = value
        self?.secureDataManagerService.saveString(value, key: key)
      }
      semaphore.signal()
    }
    
    // Ожидаем завершения асинхронной операции
    semaphore.wait()
    return retrievedValue
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  // Проверяет, что прошло больше 15 минут с сохраненной даты
  func isMoreThan15MinutesPassed() -> Bool {
    guard let storedDate = getDateFromStorage() else { return true }
    let timeInterval = Date().timeIntervalSince(storedDate)
    return timeInterval > 15 * 60
  }
  
  // Получает дату из стораджа по ключу
  func getDateFromStorage() -> Date? {
    guard let dateString = secureDataManagerService.getString(for: Constants.oneDayPassKey) else { return nil }
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter.date(from: dateString)
  }
  
  // Сохраняет текущую дату в сторадж по ключу
  func saveDateToStorage() {
    let currentDate = Date()
    let dateFormatter = ISO8601DateFormatter()
    let dateString = dateFormatter.string(from: currentDate)
    secureDataManagerService.saveString(dateString, key: Constants.oneDayPassKey)
  }
}

// MARK: - Constants

private enum Constants {
  static let supportOChatMail = "SupportOChatMail"
  static let premiumList = "PremiumList"
  static let apiKeyApphud = "ApiKeyApphud"
  static let isPremiumMode = "isPremiumMode"
  
  static let oneDayPassKey = "OneDayPassKey"
}
