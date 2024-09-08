//
//  ICloudKitService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Протокол для работы с CloudKit для получения конфигурационных данных.
public protocol ICloudKitService {
  /// Получает значение конфигурации по ключу.
  /// - Parameters:
  ///   - keyName: Имя ключа, по которому нужно получить значение.
  ///   - completion: Замыкание, которое вызывается по завершению операции. Возвращает результат типа `Result<T?, Error>`.
  func getConfigurationValue<T>(from keyName: String, completion: @escaping (Result<T?, Error>) -> Void)
}
