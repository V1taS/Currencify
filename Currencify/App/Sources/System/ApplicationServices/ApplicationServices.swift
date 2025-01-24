//
//  ApplicationServices.swift
//  Currencify
//
//  Created by Vitalii Sosin on 17.04.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import SwiftUI
import SKAbstractions
import SKServices
import SKUIKit

// MARK: - ApplicationServices

final class ApplicationServices: IApplicationServices {
  
  // MARK: - Properties
  
  /// Возвращает сервис для управления сервисами, связанными с данными в приложении
  var dataManagementService: IDataManagementService {
    DataManagementService()
  }
  
  /// Возвращает сервис для управления безопасностью и доступом в приложении.
  var accessAndSecurityManagementService: IAccessAndSecurityManagementService {
    AccessAndSecurityManagementService()
  }
  
  /// Возвращает сервис для управления интерфейсом пользователя и опытом использования приложения.
  var userInterfaceAndExperienceService: IUserInterfaceAndExperienceService {
    UserInterfaceAndExperienceService()
  }
  
  /// Возвращает сервис для работы с настройками приложения
  var appSettingsDataManager: IAppSettingsDataManager {
    AppSettingsDataManager.shared
  }
  
  /// Возвращает сервис для работы с платежами
  var appPurchasesService: IAppPurchasesService {
    AppPurchasesService.shared
  }
  
  /// Основной форматер в приложении
  var textFormatterService: ITextFormatterService {
    TextFormatterService()
  }
}
