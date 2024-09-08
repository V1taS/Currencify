//
//  AppPurchasesServiceState.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

public enum AppPurchasesServiceState {
  
  /// Успешная покупка подписки
  case successfulSubscriptionPurchase
  
  /// Успешная разовая покупка
  case successfulOneTimePurchase
  
  /// Что-то пошло не так
  case somethingWentWrong
}
