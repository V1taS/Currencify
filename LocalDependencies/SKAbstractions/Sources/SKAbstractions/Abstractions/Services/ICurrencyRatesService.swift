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
  /// - Parameter completion: Замыкание, которое возвращает словарь с кодами валют и их значениями
  func fetchCBCurrencyRates(completion: @escaping ([String: Double]) -> Void)
  
  /// Получает курсы валют от Европейского центрального банка
  /// - Parameter completion: Замыкание, которое возвращает словарь с кодами валют и их значениями
  func fetchECBCurrencyRates(completion: @escaping ([String: Double]) -> Void)
}
