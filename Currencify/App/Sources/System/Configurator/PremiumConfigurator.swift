//
//  PremiumConfigurator.swift
//  Currencify
//
//  Created by Vitalii Sosin on 08.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import SKAbstractions
import SKUIKit
import UIKit
import SKStyle
import SwiftUI

final class PremiumConfigurator: Configurator {
  
  // MARK: - Private properties
  
  private let services: IApplicationServices
  
  // MARK: - Init
  
  init(services: IApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func configure() {
    setPremium()
  }
}

// MARK: - Private

private extension PremiumConfigurator {
  func setPremium() {
    let semaphore = DispatchSemaphore(value: .zero)
    let isPremium = manualIsPremiumCheck() || checkIsPremium()
    
    services.appSettingsDataManager.setIsPremiumEnabled(isPremium) {
      semaphore.signal()
    }
    semaphore.wait()
  }
  
  func manualIsPremiumCheck() -> Bool {
    let systemService = services.userInterfaceAndExperienceService.systemService
    let vendorID = systemService.getDeviceIdentifier()
    let user = Secrets.premiumList.first(where: { $0.id == vendorID })
    return user?.isPremium ?? false
  }
  
  func checkIsPremium() -> Bool {
    let semaphore = DispatchSemaphore(value: .zero)
    var retrievedValue: Bool = false
    services.appPurchasesService.isValidatePurchase { isValidate in
      retrievedValue = isValidate
      semaphore.signal()
    }
    
    // Ожидаем завершения асинхронной операции
    semaphore.wait()
    return retrievedValue
  }
}
