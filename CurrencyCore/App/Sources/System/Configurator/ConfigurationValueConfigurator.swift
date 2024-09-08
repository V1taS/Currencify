//
//  ConfigurationValueConfigurator.swift
//  CurrencyCore
//
//  Created by Vitalii Sosin on 08.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

struct ConfigurationValueConfigurator: Configurator {
  
  // MARK: - Private properties
  
  private let services: IApplicationServices
  private var cloudKitService: ICloudKitService {
    services.dataManagementService.cloudKitService
  }
  private var secureDataManagerService: ISecureDataManagerService {
    services.dataManagementService.getSecureDataManagerService(.configurationSecrets)
  }
  
  // MARK: - Init
  
  init(services: IApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func configure() {
    getFredApi()
    getApiKeyApphud()
    getSupportOChatMail()
    getPremiumList()
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  func getFredApi() {
    if let value = getConfigurationValue(forKey: Constants.fredApi) {
      Secrets.fredApi = value
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
    
    cloudKitService.getConfigurationValue(from: key) { (result: Result<String?, Error>) in
      if case let .success(value) = result, let value {
        retrievedValue = value
        secureDataManagerService.saveString(value, key: key)
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
  static let fredApi = "FredApi"
  
  static let oneDayPassKey = "OneDayPassKey"
}
