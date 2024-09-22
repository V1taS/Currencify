//
//  SettingsScreenInteractor.swift
//  Currencify
//
//  Created by Vitalii Sosin on 21.04.2024.
//

import SwiftUI
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol SettingsScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol SettingsScreenInteractorInput {
  /// Возвращает текущий язык приложения.
  func getCurrentLanguage() -> AppLanguageType
  
  /// Возвращает текущую версию приложения.
  /// - Returns: Строка с версией приложения, например, "1.0".
  func getAppVersion() -> String
  
  /// Копирует текст в буфер обмена.
  /// - Parameters:
  ///   - text: Текст для копирования.
  func copyToClipboard(text: String)
  
  /// Показать уведомление
  /// - Parameters:
  ///   - type: Тип уведомления
  func showNotification(_ type: NotificationServiceType)
  
  /// Удалить все данные из основной модели
  @discardableResult
  func deleteAllData() async -> Bool
  
  /// Получить модель настроек приложения
  /// - Returns: Асинхронная операция, возвращающая модель настроек `AppSettingsModel`
  func getAppSettingsModel() async -> AppSettingsModel
  
  /// Получить статус премиума
  func getIsPremiumState() async -> Bool
  
  /// Устанавливает количество знаков после запятой для отображения валютных значений.
  func setCurrencyDecimalPlaces(_ value: CurrencyDecimalPlaces) async
  
  /// Загрузить курсы из нового источника
  func fetchurrencyRates() async
  
  /// Устанавливает корекцию текущего курса в процентах
  /// - Parameters:
  ///   - value: Значение корректировки в проценте
  func setRateCorrectionPercentage(_ value: Double) async
  
  /// Устанавливает типы валют.
  func setCurrencyTypes(_ currencyTypes: [CurrencyRate.CurrencyType]) async
  
  /// Удаляет типы валют.
  func removeCurrencyTypes(_ currencyTypes: [CurrencyRate.CurrencyType]) async
}

/// Интерактор
final class SettingsScreenInteractor {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let systemService: ISystemService
  private let notificationService: INotificationService
  private let appSettingsDataManager: IAppSettingsDataManager
  private let dataManagementService: IDataManagementService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы
  init(_ services: IApplicationServices) {
    systemService = services.userInterfaceAndExperienceService.systemService
    notificationService = services.userInterfaceAndExperienceService.notificationService
    appSettingsDataManager = services.appSettingsDataManager
    dataManagementService = services.dataManagementService
  }
}

// MARK: - SettingsScreenInteractorInput

extension SettingsScreenInteractor: SettingsScreenInteractorInput {
  func setCurrencyTypes(_ currencyTypes: [CurrencyRate.CurrencyType]) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setCurrencyTypes(currencyTypes) {
        continuation.resume()
      }
    }
  }
  
  func removeCurrencyTypes(_ currencyTypes: [CurrencyRate.CurrencyType]) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.removeCurrencyTypes(currencyTypes) {
        continuation.resume()
      }
    }
  }
  
  func setRateCorrectionPercentage(_ value: Double) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setRateCorrectionPercentage(value) {
        continuation.resume()
      }
    }
  }
  
  func fetchurrencyRates() async {
    await withCheckedContinuation { continuation in
      dataManagementService.currencyRatesService.fetchCurrencyRates {
        continuation.resume()
      }
    }
  }
  
  func setCurrencyDecimalPlaces(_ value: CurrencyDecimalPlaces) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setCurrencyDecimalPlaces(value) {
        continuation.resume()
      }
    }
  }
  
  func getIsPremiumState() async -> Bool {
    await getAppSettingsModel().isPremium
  }
  
  func getAppSettingsModel() async -> AppSettingsModel {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.getAppSettingsModel { appSettingsModel in
        continuation.resume(returning: appSettingsModel)
      }
    }
  }
  
  func deleteAllData() async -> Bool {
    appSettingsDataManager.deleteAllData()
  }
  
  func copyToClipboard(text: String) {
    systemService.copyToClipboard(text: text)
  }
  
  func showNotification(_ type: NotificationServiceType) {
    notificationService.showNotification(type)
  }
  
  func getAppVersion() -> String {
    systemService.getAppVersion()
  }
  
  func getCurrentLanguage() -> AppLanguageType {
    systemService.getCurrentLanguage()
  }
}

// MARK: - Private

private extension SettingsScreenInteractor {}

// MARK: - Constants

private enum Constants {}
