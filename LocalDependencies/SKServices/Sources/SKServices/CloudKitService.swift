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
  /// Инициализирует новый экземпляр CloudKitService.
  public init() {}
  
  public func getConfigurationValue<T>(from keyName: String, completion: @escaping (Result<T?, Error>) -> Void) {
    let container = CKContainer(identifier: "iCloud.com.sosinvitalii.CurrencyCore")
    let publicDatabase = container.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Config", predicate: predicate)
    
    publicDatabase.fetch(withQuery: query) { result in
      switch result {
      case .success(let success):
        guard case let .success(record) = success.matchResults.first?.1,
              let value = record[keyName] as? T else {
          completion(.success(nil))
          return
        }
        completion(.success(value))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
