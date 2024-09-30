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
      return "com.sosinvitalii.Currencify.YearlyPremiumAccessSubscriptionsNew"
    case .monthly:
      return "com.sosinvitalii.Currencify.MonthlyPremiumAccessSubscriptionsNew"
    case .lifetime:
      return "com.sosinvitalii.Currencify.OneTimePurchasePremiumAccess"
    case .lifetimeSale:
      return "com.sosinvitalii.Currencify.OneTimePurchasePremiumAccessSale"
    }
  }
  
  /// Ежемесячная подписка
  case monthly
  
  /// Ежегодная подписка
  case yearly
  
  /// Погупка навсегда
  case lifetime
  
  /// Погупка навсегда (Распродажа)
  case lifetimeSale
}
