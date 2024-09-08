//
//  CBCurrencyRates.swift
//  SKServices
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Модель для работы с API Центробанка РФ.
/// Содержит метод для получения списка валют по курсу.
struct CBCurrencyRates {}

/// Расширение для модели, связанное с валютами.
extension CBCurrencyRates {
  
  /// Модель валюты, возвращаемой Центробанком РФ.
  struct Valute: Codable {
    /// Код валюты (например, USD).
    let charCode: String
    
    /// Название валюты (например, Доллар США).
    let name: String
    
    /// Курс валюты относительно рубля.
    let value: Double
    
    enum CodingKeys: String, CodingKey {
      case charCode = "CharCode"
      case name = "Name"
      case value = "Value"
    }
  }
  
  /// Модель ответа от Центробанка РФ.
  struct CBRResponse: Codable {
    /// Словарь с валютами, где ключ - это код валюты, а значение - объект `Valute`.
    let valute: [String: Valute]
    
    enum CodingKeys: String, CodingKey {
      case valute = "Valute"
    }
  }
}
