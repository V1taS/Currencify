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
  
  /// Выбранные валюты
  public var selectedCurrencyRate: [CurrencyRate.Currency]
  
  /// Источник курсов валют
  public var currencySource: CurrencySource
  
  /// Количество знаков после запятой для отображения валютных значений.
  public var currencyDecimalPlaces: CurrencyDecimalPlaces
  
  /// Корекция текущего курса в процентах
  public var rateCorrectionPercentage: Double
  
  /// Последнее значение которое ввел пользователь
  public var enteredCurrencyAmount: Double
  
  /// Валюта последнего значения что расчитывал пользователь
  public var activeCurrency: CurrencyRate.Currency
  
  /// Инициализирует новый экземпляр `AppSettingsModel`
  /// - Parameters:
  ///   - isPremium: Премиум режим
  ///   - selectedCurrencyRate: Выбранные валюты
  ///   - currencySource: Источник курсов валют
  ///   - currencyDecimalPlaces: Количество знаков после запятой для отображения валютных значений
  ///   - rateCorrectionPercentage: Корекция текущего курса в процентах
  ///   - enteredCurrencyAmount: Последнее значение которое ввел пользователь
  ///   - activeCurrency: Валюта последнего значения что расчитывал пользователь
  public init(
    isPremium: Bool,
    selectedCurrencyRate: [CurrencyRate.Currency],
    currencySource: CurrencySource,
    currencyDecimalPlaces: CurrencyDecimalPlaces,
    rateCorrectionPercentage: Double,
    enteredCurrencyAmount: Double,
    activeCurrency: CurrencyRate.Currency
  ) {
    self.isPremium = isPremium
    self.selectedCurrencyRate = selectedCurrencyRate
    self.currencySource = currencySource
    self.currencyDecimalPlaces = currencyDecimalPlaces
    self.rateCorrectionPercentage = rateCorrectionPercentage
    self.enteredCurrencyAmount = enteredCurrencyAmount
    self.activeCurrency = activeCurrency
  }
}

// MARK: - Set default values

extension AppSettingsModel {
  public static func setDefaultValues() -> Self {
    return .init(
      isPremium: true,
      selectedCurrencyRate: [
        .USD,
        .EUR,
        .RUB
      ],
      currencySource: .cbr, 
      currencyDecimalPlaces: .two, 
      rateCorrectionPercentage: .zero,
      enteredCurrencyAmount: .zero,
      activeCurrency: .USD
    )
  }
}

// MARK: - IdentifiableAndCodable

extension AppSettingsModel: IdentifiableAndCodable {}
