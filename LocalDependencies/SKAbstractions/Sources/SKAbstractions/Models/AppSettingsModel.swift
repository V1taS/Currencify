//
//  AppSettingsModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 17.05.2024.
//

import Foundation

/// Модель, представляющая настройки приложения.
public struct AppSettingsModel {
  /// Премиум режим
  public var isPremium: Bool
  
  /// Все валюты
  public var allCurrencyRate: [CurrencyRate]
  
  /// Выбранные валюты
  public var selectedCurrencyRate: [CurrencyRate.Currency]
  
  /// Типы валют
  public var currencyTypes: [CurrencyRate.CurrencyType]
  
  /// Количество знаков после запятой для отображения валютных значений.
  public var currencyDecimalPlaces: CurrencyDecimalPlaces
  
  /// Корекция текущего курса в процентах
  public var rateCorrectionPercentage: Double
  
  /// Последнее значение которое ввел пользователь
  public var enteredCurrencyAmount: Double
  
  /// Валюта последнего значения что расчитывал пользователь
  public var activeCurrency: CurrencyRate.Currency
  
  /// Список премиум пользователей
  public var premiumList: [PremiumModel]
  
  /// Инициализирует новый экземпляр `AppSettingsModel`
  /// - Parameters:
  ///   - isPremium: Премиум режим
  ///   - allCurrencyRate: Все валюты
  ///   - selectedCurrencyRate: Выбранные валюты
  ///   - currencyTypes: Типы валют
  ///   - currencyDecimalPlaces: Количество знаков после запятой для отображения валютных значений
  ///   - rateCorrectionPercentage: Корекция текущего курса в процентах
  ///   - enteredCurrencyAmount: Последнее значение которое ввел пользователь
  ///   - activeCurrency: Валюта последнего значения что расчитывал пользователь
  ///   - premiumList: Список премиум пользователей
  public init(
    isPremium: Bool,
    allCurrencyRate: [CurrencyRate],
    selectedCurrencyRate: [CurrencyRate.Currency],
    currencyTypes: [CurrencyRate.CurrencyType],
    currencyDecimalPlaces: CurrencyDecimalPlaces,
    rateCorrectionPercentage: Double,
    enteredCurrencyAmount: Double,
    activeCurrency: CurrencyRate.Currency,
    premiumList: [PremiumModel]
  ) {
    self.isPremium = isPremium
    self.allCurrencyRate = allCurrencyRate
    self.selectedCurrencyRate = selectedCurrencyRate
    self.currencyTypes = currencyTypes
    self.currencyDecimalPlaces = currencyDecimalPlaces
    self.rateCorrectionPercentage = rateCorrectionPercentage
    self.enteredCurrencyAmount = enteredCurrencyAmount
    self.activeCurrency = activeCurrency
    self.premiumList = premiumList
  }
}

// MARK: - Set default values

extension AppSettingsModel {
  public static func setDefaultValues() -> Self {
    return .init(
      isPremium: true,
      allCurrencyRate: [],
      selectedCurrencyRate: [
        .USD,
        .EUR,
        .RUB
      ],
      currencyTypes: [.currency],
      currencyDecimalPlaces: .two,
      rateCorrectionPercentage: .zero,
      enteredCurrencyAmount: .zero,
      activeCurrency: .USD, 
      premiumList: []
    )
  }
}

// MARK: - IdentifiableAndCodable

extension AppSettingsModel: IdentifiableAndCodable {}
