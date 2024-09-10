//
//  ICurrencyRatesService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Протокол для получения курсов валют
public protocol ICurrencyRatesService {
  
  /// Получает курсы валют от Центрального банка России
  /// - Parameter completion: Замыкание, которое возвращает массив моделей валют и их значений
  func fetchCBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void)
  
  /// Получает курсы валют от Европейского Центрального Банка
  /// - Parameter completion: Замыкание, которое возвращает массив моделей валют и их значений
  func fetchECBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void)
}
