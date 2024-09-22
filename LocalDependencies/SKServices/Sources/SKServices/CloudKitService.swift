//
//  CloudKitService.swift
//  SKServices
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation
import CloudKit
import SKAbstractions

// MARK: - CloudKitService

public final class CloudKitService: ICloudKitService {
  /// Интервал таймаута для запросов в секундах.
  private let timeoutInterval: TimeInterval = 10
  
  /// Инициализирует новый экземпляр CloudKitService.
  public init() {}
  
  public func getConfigurationValue<T>(from keyName: String, completion: @escaping (Result<T?, Error>) -> Void) {
    let container = CKContainer(identifier: "iCloud.com.sosinvitalii.Currencify")
    let publicDatabase = container.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Config", predicate: predicate)
    
    // Создаём DispatchWorkItem для таймаута
    let timeoutWorkItem = DispatchWorkItem {
      completion(
        .failure(
          NSError(
            domain: "CloudKitService",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Request timed out"]
          )
        )
      )
    }
    
    // Планируем выполнение таймаута через timeoutInterval секунд
    DispatchQueue.global().asyncAfter(deadline: .now() + timeoutInterval, execute: timeoutWorkItem)
    
    // Выполняем запрос к CloudKit
    publicDatabase.perform(query, inZoneWith: nil) { records, error in
      // Отменяем таймаут, если запрос завершился раньше
      timeoutWorkItem.cancel()
      
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let records = records else {
        completion(.success(nil))
        return
      }
      
      if let firstRecord = records.first {
        if let value = firstRecord[keyName] as? T {
          completion(.success(value))
        } else {
          completion(.success(nil))
        }
      } else {
        completion(.success(nil))
      }
    }
  }
}
