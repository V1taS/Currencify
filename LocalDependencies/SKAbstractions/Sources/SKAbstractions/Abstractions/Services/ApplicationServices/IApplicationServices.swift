//
//  IApplicationServices.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 17.04.2024.
//

import Foundation

// MARK: - IApplicationServices

public protocol IApplicationServices {
  /// Возвращает сервис для управления сервисами, связанными с данными в приложении
  var dataManagementService: IDataManagementService { get }
  
  /// Возвращает сервис для управления безопасностью и доступом в приложении.
  var accessAndSecurityManagementService: IAccessAndSecurityManagementService { get }
  
  /// Возвращает сервис для управления интерфейсом пользователя и опытом использования приложения.
  var userInterfaceAndExperienceService: IUserInterfaceAndExperienceService { get }
  
  /// Работа с настройками приложения
  var appSettingsDataManager: IAppSettingsDataManager { get }
  
  /// Работа с платежами в приложении
  var appPurchasesService: IAppPurchasesService { get }
  
  /// Основной форматер в приложении
  var textFormatterService: ITextFormatterService { get }
}
