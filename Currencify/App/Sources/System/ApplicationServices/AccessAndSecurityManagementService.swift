//
//  AccessAndSecurityManagementService.swift
//  Currencify
//
//  Created by Vitalii Sosin on 31.05.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions
import SKServices

// MARK: - AccessAndSecurityManagementService

final class AccessAndSecurityManagementService: IAccessAndSecurityManagementService {

  // MARK: - Properties
  
  /// Возвращает сервис запроса доступов.
  var permissionService: IPermissionService {
    PermissionService()
  }
  
  /// Сервис по проверки доступности интернета
  var networkReachabilityService: INetworkReachabilityService? {
    networkReachabilityServiceImpl
  }
}

private let networkReachabilityServiceImpl = NetworkReachabilityService()
