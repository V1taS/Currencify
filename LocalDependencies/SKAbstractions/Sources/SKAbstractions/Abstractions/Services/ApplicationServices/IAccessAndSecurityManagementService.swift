//
//  IAccessAndSecurityManagementService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 31.05.2024.
//

import Foundation

/// Протокол для управления безопасностью и доступом в приложении.
public protocol IAccessAndSecurityManagementService {
  /// Возвращает сервис запроса доступов.
  /// - Returns: Сервис управления доступами.
  var permissionService: IPermissionService { get }
}
