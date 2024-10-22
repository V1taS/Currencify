//
//  INetworkReachabilityService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 22.10.2024.
//

import Foundation

public protocol INetworkReachabilityService {
  
  /// Доступность интернета
  var isReachable: Bool { get }
}
