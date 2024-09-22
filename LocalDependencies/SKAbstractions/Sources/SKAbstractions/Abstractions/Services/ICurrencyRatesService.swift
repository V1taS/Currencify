//
//  ICurrencyRatesService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Протокол для получения курсов валют
public protocol ICurrencyRatesService {
  /// Получает курсы валют из всех доступных источников
  /// - Parameter completion: Опциональное замыкание, которое вызывается после завершения операции
  func fetchCurrencyRates(_ completion: (() -> Void)?)
}
