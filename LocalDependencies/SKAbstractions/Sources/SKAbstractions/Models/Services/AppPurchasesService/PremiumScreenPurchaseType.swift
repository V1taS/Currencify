//
//  PremiumScreenPurchaseType.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

public enum PremiumScreenPurchaseType: CaseIterable {
  
  /// ID продукта
  public var productIdentifiers: String {
    switch self {
    case .yearly:
      return "com.sosinvitalii.CurrencyCore.YearlyPremiumAccess"
    case .monthly:
      return "com.sosinvitalii.CurrencyCore.MonthlyPremiumAccess"
    case .lifetime:
      return "com.sosinvitalii.CurrencyCore.OneTimePurchasePremiumAccess"
    }
  }
  
  /// Ежемесячная подписка
  case monthly
  
  /// Ежегодная подписка
  case yearly
  
  /// Погупка навсегда
  case lifetime
}
