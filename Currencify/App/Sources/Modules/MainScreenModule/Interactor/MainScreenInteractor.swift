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
  func fetchCurrencyRates() async
  
  /// Получить модель настроек приложения
  func getAppSettingsModel() async -> AppSettingsModel
  
  /// Добавляет указанные валюты в список выбранных, если они ещё не добавлены.
  /// - Parameters:
  ///   - currencyRates: Массив валют для добавления.
  func setSelectedCurrencyRates(_ currencyRates: [CurrencyRate.Currency]) async
  
  /// Удаляет указанные валюты из списка выбранных.
  /// - Parameters:
  ///   - currencyRates: Массив валют для удаления.
  func removeCurrencyRates(_ currencyRates: [CurrencyRate.Currency]) async
  
  /// Удаляет все выбранные валюты из списка.
  func removeAllCurrencyRates() async
  
  /// Устанавливает введённую сумму валюты.
  /// - Parameters:
  ///   - value: Строка, представляющая введённую сумму валюты.
  func setEnteredCurrencyAmount(_ value: Double) async
  
  /// Устанавливает активную валюту для отображения курсов.
  /// - Parameters:
  ///   - value: Валюта, которая будет установлена как активная.
  func setActiveCurrency(_ value: CurrencyRate.Currency) async
  
  /// Создание снимка коллекции.
  func createCollectionViewSnapshot() async -> UIImage?
  
  /// Запрос доступа к Галерее
  /// - Parameter return: Булево значение, указывающее, было ли предоставлено разрешение
  @discardableResult
  func requestGallery() async -> Bool
}

/// Интерактор
final class MainScreenInteractor {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let currencyRatesService: ICurrencyRatesService
  private let appSettingsDataManager: IAppSettingsDataManager
  private let uiService: IUIService
  private let permissionService: IPermissionService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  init(services: IApplicationServices) {
    currencyRatesService = services.dataManagementService.currencyRatesService
    appSettingsDataManager = services.appSettingsDataManager
    uiService = services.userInterfaceAndExperienceService.uiService
    permissionService = services.accessAndSecurityManagementService.permissionService
  }
}

// MARK: - MainScreenInteractorInput

extension MainScreenInteractor: MainScreenInteractorInput {
  func requestGallery() async -> Bool {
    await permissionService.requestGallery()
  }
  
  func createCollectionViewSnapshot() async -> UIImage? {
    await withCheckedContinuation { continuation in
      uiService.createCollectionViewSnapshot { image in
        continuation.resume(returning: image)
      }
    }
  }
  
  func fetchCurrencyRates() async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.getAppSettingsModel { [weak self] appSettingsModel in
        guard let self else { return }
        switch appSettingsModel.currencySource {
        case .cbr:
          currencyRatesService.fetchCBCurrencyRates { [weak self] models in
            if !models.isEmpty {
              self?.appSettingsDataManager.setAllCurrencyRate(models) {
                continuation.resume()
              }
            } else {
              continuation.resume()
            }
          }
        case .ecb:
          currencyRatesService.fetchECBCurrencyRates { [weak self] models in
            if !models.isEmpty {
              self?.appSettingsDataManager.setAllCurrencyRate(models) {
                continuation.resume()
              }
            } else {
              continuation.resume()
            }
          }
        }
      }
    }
  }
  
  func getAppSettingsModel() async -> AppSettingsModel {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.getAppSettingsModel { appSettingsModel in
        continuation.resume(returning: appSettingsModel)
      }
    }
  }
  
  func setSelectedCurrencyRates(_ currencyRates: [CurrencyRate.Currency]) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setSelectedCurrencyRates(currencyRates) {
        continuation.resume()
      }
    }
  }
  
  func removeCurrencyRates(_ currencyRates: [CurrencyRate.Currency]) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.removeCurrencyRates(currencyRates) {
        continuation.resume()
      }
    }
  }
  
  func removeAllCurrencyRates() async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.removeAllCurrencyRates {
        continuation.resume()
      }
    }
  }
  
  func setEnteredCurrencyAmount(_ value: Double) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setEnteredCurrencyAmount(value) {
        continuation.resume()
      }
    }
  }
  
  func setActiveCurrency(_ value: CurrencyRate.Currency) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setActiveCurrency(value) {
        continuation.resume()
      }
    }
  }
}

// MARK: - Private

private extension MainScreenInteractor {}

// MARK: - Constants

private enum Constants {}
