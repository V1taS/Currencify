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
  
  /// Инициализирует новый экземпляр `AppSettingsModel`
  /// - Parameters:
  ///   - isPremium: Премиум режим
  ///   - selectedCurrencyRate: Выбранные валюты
  ///   - currencySource: Источник курсов валют
  ///   - currencyDecimalPlaces: Количество знаков после запятой для отображения валютных значений.
  public init(
    isPremium: Bool,
    selectedCurrencyRate: [CurrencyRate.Currency],
    currencySource: CurrencySource,
    currencyDecimalPlaces: CurrencyDecimalPlaces
  ) {
    self.isPremium = isPremium
    self.selectedCurrencyRate = selectedCurrencyRate
    self.currencySource = currencySource
    self.currencyDecimalPlaces = currencyDecimalPlaces
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
      currencyDecimalPlaces: .two
    )
  }
}

// MARK: - IdentifiableAndCodable

extension AppSettingsModel: IdentifiableAndCodable {}
