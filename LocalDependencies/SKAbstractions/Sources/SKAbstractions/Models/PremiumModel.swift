//
//  PremiumModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 11.08.2024.
//

import Foundation

/// Модель данных для премиум-пользователя.
public struct PremiumModel {
  
  /// Уникальное ID устройства
  public let id: String
  
  /// Включен ли Премиум
  public let isPremium: Bool
  
  /// Имя
  public let name: String?
  
  /// Инициализатор для создания модели премиум-пользователя.
  /// - Parameters:
  ///   - id: Уникальный идентификатор устройства.
  ///   - isPremium: Флаг, указывающий, является ли пользователь премиум.
  ///   - name: Опциональное имя пользователя.
  public init(
    id: String,
    isPremium: Bool,
    name: String?
  ) {
    self.id = id
    self.isPremium = isPremium
    self.name = name
  }
  
  // MARK: - Public funcs
  
  /// Метод для декодирования JSON в массив объектов `PremiumModel`.
  ///
  /// - Parameter jsonData: Данные JSON, которые нужно декодировать.
  /// - Returns: Массив объектов `PremiumModel` или `nil`, если декодирование не удалось.
  public static func decodeFromJSON(_ jsonData: Data) -> [PremiumModel] {
    let decoder = JSONDecoder()
    do {
      let premiums = try decoder.decode([PremiumModel].self, from: jsonData)
      return premiums
    } catch {
      print("Ошибка декодирования JSON: \(error)")
      return []
    }
  }
}

// MARK: - IdentifiableAndCodable

extension PremiumModel: IdentifiableAndCodable {}
