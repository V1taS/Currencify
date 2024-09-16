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
    
    /// Номинал валюты.
    let nominal: Int
    
    /// Курс валюты относительно рубля.
    let value: Double
    
    /// Предыдущий курс валюты.
    let previous: Double
    
    enum CodingKeys: String, CodingKey {
      case charCode = "CharCode"
      case name = "Name"
      case nominal = "Nominal"
      case value = "Value"
      case previous = "Previous"
    }
  }
  
  /// Модель ответа от Центробанка РФ.
  struct CBRResponse: Codable {
    /// Словарь с валютами, где ключ - это код валюты, а значение - объект `Valute`.
    let valute: [String: Valute]
    
    /// Дата актуального курса.
    let date: Date
    
    enum CodingKeys: String, CodingKey {
      case valute = "Valute"
      case date = "Date"
    }
    
    // Кастомный инициализатор для парсинга даты
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.valute = try container.decode([String: Valute].self, forKey: .valute)
      
      let dateString = try container.decode(String.self, forKey: .date)
      
      // Создаем DateFormatter для парсинга даты
      let dateFormatter = ISO8601DateFormatter()
      dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      
      // Парсим строку даты в тип Date
      if let parsedDate = dateFormatter.date(from: dateString) {
        self.date = parsedDate
      } else {
        // Попробуем другой формат, если первый не подошёл
        let alternativeFormatter = DateFormatter()
        alternativeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        if let parsedDate = alternativeFormatter.date(from: dateString) {
          self.date = parsedDate
        } else {
          throw DecodingError.dataCorruptedError(
            forKey: .date,
            in: container,
            debugDescription: "Неверный формат даты"
          )
        }
      }
    }
  }
}
