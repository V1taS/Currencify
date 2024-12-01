//
//  MainScreenInteractor.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI
import SKAbstractions
import SKUIKit

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
  func setEnteredCurrencyAmountRaw(_ value: String) async
  
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
  
  /// Делаем расчет всех валют
  func recalculateCurrencyRates(
    appSettingsModel: AppSettingsModel,
    rawCurrencyRate: String
  ) async -> [CurrencyRateIdentifiable]
  
  /// Установить значение показана ли клавиатура
  func setUserInputIsVisible(_ value: Bool) async
  
  /// Сервис по форматированию текста
  var textFormatterService: ITextFormatterService { get set }
  
  /// Доступность интернета
  var isReachable: Bool { get }
}

/// Интерактор
final class MainScreenInteractor {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  var textFormatterService: ITextFormatterService
  
  // MARK: - Private properties
  
  private let currencyRatesService: ICurrencyRatesService
  private let appSettingsDataManager: IAppSettingsDataManager
  private let uiService: IUIService
  private let permissionService: IPermissionService
  private let networkReachabilityService: INetworkReachabilityService?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  init(services: IApplicationServices) {
    currencyRatesService = services.dataManagementService.currencyRatesService
    appSettingsDataManager = services.appSettingsDataManager
    uiService = services.userInterfaceAndExperienceService.uiService
    permissionService = services.accessAndSecurityManagementService.permissionService
    textFormatterService = services.textFormatterService
    networkReachabilityService = services.accessAndSecurityManagementService.networkReachabilityService
  }
}

// MARK: - MainScreenInteractorInput

extension MainScreenInteractor: MainScreenInteractorInput {
  var isReachable: Bool {
    networkReachabilityService?.isReachable ?? false
  }
  
  func recalculateCurrencyRates(
    appSettingsModel: AppSettingsModel,
    rawCurrencyRate: String
  ) async -> [CurrencyRateIdentifiable] {
    let availableRates = appSettingsModel.selectedCurrencyRate
    let currencyTypes = appSettingsModel.currencyTypes
    
    let allCurrencyRates: [CurrencyRate] = CurrencyRate.calculateCurrencyRates(
      from: appSettingsModel.activeCurrency,
      amount: Double(appSettingsModel.enteredCurrencyAmountRaw) ?? .zero,
      calculationMode: .inverse,
      allCurrencyRate: appSettingsModel.allCurrencyRate
    )
    let filteredCurrencyRates = allCurrencyRates.filter { currencyRate in
      availableRates.contains { selectedCurrency in
        currencyRate.currency == selectedCurrency &&
        currencyTypes.contains(currencyRate.currency.details.source)
      }
    }
    
    let sortedCurrencyRates = filteredCurrencyRates.sorted { first, second in
      guard let firstIndex = availableRates.firstIndex(of: first.currency),
            let secondIndex = availableRates.firstIndex(of: second.currency) else {
        return false
      }
      return firstIndex < secondIndex
    }
    
    let currencyTextRates = await getTextCurrencyRates(
      currencyRates: sortedCurrencyRates,
      selectedCurrency: appSettingsModel.activeCurrency,
      rateCorrectionPercentage: appSettingsModel.rateCorrectionPercentage,
      currencyDecimalPlaces: appSettingsModel.currencyDecimalPlaces,
      rawCurrencyRate: rawCurrencyRate
    )
    
    return currencyTextRates
  }
  
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
    let appSettingsModel = await getAppSettingsModel()
    
    if appSettingsModel.allCurrencyRate.isEmpty {
      startLoader()
    }
    
    await withCheckedContinuation { continuation in
      currencyRatesService.fetchCurrencyRates {
        stopLoader()
        continuation.resume()
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
  
  func setUserInputIsVisible(_ value: Bool) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setUserInputIsVisible(value) {
        continuation.resume()
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
  
  func setEnteredCurrencyAmountRaw(_ value: String) async {
    await withCheckedContinuation { continuation in
      appSettingsDataManager.setEnteredCurrencyAmountRaw(value) {
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

private extension MainScreenInteractor {
  func applyRateCorrection(to currencyRate: CurrencyRate, correctionPercentage: Double) -> CurrencyRate {
    let correctedRate = currencyRate.rate * (1 + correctionPercentage / 100)
    return CurrencyRate(
      currency: currencyRate.currency,
      rate: correctedRate,
      lastUpdated: currencyRate.lastUpdated
    )
  }
  
  func getTextCurrencyRates(
    currencyRates: [CurrencyRate],
    selectedCurrency: CurrencyRate.Currency,
    rateCorrectionPercentage: Double,
    currencyDecimalPlaces: CurrencyDecimalPlaces,
    rawCurrencyRate: String
  ) async -> [CurrencyRateIdentifiable] {
    var models: [CurrencyRateIdentifiable] = []
    for currencyRate in currencyRates {
      var rate = currencyRate.rate

      if rateCorrectionPercentage != .zero, currencyRate.currency != selectedCurrency {
        let correctedCurrencyRates = applyRateCorrection(
          to: currencyRate,
          correctionPercentage: rateCorrectionPercentage
        )
        rate = correctedCurrencyRates.rate
      }
      
      let currencyValue = textFormatterService.formatDouble(
        rate,
        decimalPlaces: currencyDecimalPlaces.rawValue
      )
      let currencyValueReplaceDotsWithCommas = textFormatterService.replaceDotsWithCommas(in: currencyValue)
      var currencyValueRemoveExtraZeros = textFormatterService.removeExtraZeros(
        from: currencyValueReplaceDotsWithCommas
      )
      
      if currencyRate.currency == selectedCurrency {
        currencyValueRemoveExtraZeros = rawCurrencyRate
      }
      
      models.append(
        .init(
          currency: currencyRate.currency,
          imageURL: URL(string: currencyRate.imageURL ?? ""),
          rateText: currencyValueRemoveExtraZeros,
          rateDouble: currencyRate.rate
        )
      )
    }
    
    return models
  }
}

// MARK: - Constants

private enum Constants {}
