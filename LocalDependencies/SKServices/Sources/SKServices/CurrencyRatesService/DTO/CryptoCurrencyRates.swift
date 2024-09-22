//
//  CryptoCurrencyRates.swift
//  SKServices
//
//  Created by Vitalii Sosin on 22.09.2024.
//

import Foundation

/// Модель для работы с API CoinGecko.
struct CryptoCurrencyRates {}

/// Расширение для модели, связанной с криптовалютами.
extension CryptoCurrencyRates {
  
  /// Модель криптовалюты, возвращаемой CoinGecko.
  struct CryptoCurrency: Codable {
    /// Идентификатор криптовалюты (например, bitcoin).
    let id: String
    
    /// Название криптовалюты (например, Bitcoin).
    let name: String
    
    /// Символ криптовалюты (например, BTC).
    let symbol: String
    
    /// URL изображения криптовалюты.
    let image: String
    
    /// Текущая цена криптовалюты относительно указанной валюты (например, USD).
    let currentPrice: Double
    
    /// Время последнего обновления цены.
    let lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
      case id
      case name
      case symbol
      case image
      case currentPrice = "current_price"
      case lastUpdated = "last_updated"
    }
  }
}
