//
//  MainScreenInteractor.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol MainScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
  /// Получает курсы валют от Центрального банка России
  /// - Parameter completion: Замыкание, которое возвращает словарь с кодами валют и их значениями
  func fetchCBCurrencyRates(completion: @escaping () -> Void)
  
  /// Получить модель настроек приложения
  /// - Parameter completion: Замыкание, которое будет вызвано после получения данных. Возвращает модель настроек `AppSettingsModel`
  func getAppSettingsModel(completion: @escaping (AppSettingsModel) -> Void)
  
  /// Добавляет указанные валюты в список выбранных, если они ещё не добавлены.
  /// - Parameters:
  ///   - currencyRates: Массив валют для добавления.
  ///   - completion: Замыкание, которое будет вызвано после завершения операции.
  func setSelectedCurrencyRates(
    _ currencyRates: [CurrencyRate.Currency],
    completion: @escaping () -> Void
  )
  
  /// Удаляет указанные валюты из списка выбранных.
  /// - Parameters:
  ///   - currencyRates: Массив валют для удаления.
  ///   - completion: Замыкание, которое будет вызвано после завершения операции.
  func removeCurrencyRates(
    _ currencyRates: [CurrencyRate.Currency],
    completion: @escaping () -> Void
  )
  
  /// Удаляет все выбранные валюты из списка.
  /// - Parameter completion: Замыкание, которое будет вызвано после завершения операции.
  func removeAllCurrencyRates(
    completion: @escaping () -> Void
  )
}

/// Интерактор
final class MainScreenInteractor {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let currencyRatesService: ICurrencyRatesService
  private let appSettingsDataManager: IAppSettingsDataManager
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  init(services: IApplicationServices) {
    currencyRatesService = services.dataManagementService.currencyRatesService
    appSettingsDataManager = services.appSettingsDataManager
  }
}

// MARK: - MainScreenInteractorInput

extension MainScreenInteractor: MainScreenInteractorInput {
  func getAppSettingsModel(completion: @escaping (AppSettingsModel) -> Void) {
    appSettingsDataManager.getAppSettingsModel(completion: completion)
  }
  
  func setSelectedCurrencyRates(_ currencyRates: [CurrencyRate.Currency], completion: @escaping () -> Void) {
    appSettingsDataManager.setSelectedCurrencyRates(currencyRates, completion: completion)
  }
  
  func removeCurrencyRates(_ currencyRates: [CurrencyRate.Currency], completion: @escaping () -> Void) {
    appSettingsDataManager.removeCurrencyRates(currencyRates, completion: completion)
  }
  
  func removeAllCurrencyRates(completion: @escaping () -> Void) {
    appSettingsDataManager.removeAllCurrencyRates(completion: completion)
  }
  
  /// Получает курсы валют от Центрального банка России
  /// - Parameter completion: Замыкание, которое возвращает словарь с кодами валют и их значениями
  func fetchCBCurrencyRates(completion: @escaping () -> Void) {
    DispatchQueue.global().async { [weak self] in
      guard let self else { return }
      appSettingsDataManager.getAppSettingsModel { [weak self] appSettingsModel in
        guard let self else { return }
        switch appSettingsModel.currencySource {
        case .cbr:
          currencyRatesService.fetchCBCurrencyRates { models in
            DispatchQueue.main.async {
              Secrets.currencyRateList = models
              completion()
            }
          }
        case .ecb:
          currencyRatesService.fetchECBCurrencyRates {  models in
            DispatchQueue.main.async {
              Secrets.currencyRateList = models
              completion()
            }
          }
        }
      }
    }
  }
}

// MARK: - Private

private extension MainScreenInteractor {}

// MARK: - Constants

private enum Constants {}
