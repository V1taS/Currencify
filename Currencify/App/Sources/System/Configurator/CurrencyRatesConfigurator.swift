//
//  CurrencyRatesConfigurator.swift
//  Currencify
//
//  Created by Vitalii Sosin on 08.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import SKAbstractions
import SKUIKit
import SKStyle
import SwiftUI

struct CurrencyRatesConfigurator: Configurator {
  
  // MARK: - Private properties
  
  private let services: IApplicationServices
  
  // MARK: - Init
  
  init(services: IApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func configure() {
    let semaphore = DispatchSemaphore(value: 0)
    
    services.appSettingsDataManager.getAppSettingsModel { appSettingsModel in
      switch appSettingsModel.currencySource {
      case .cbr:
        services.dataManagementService.currencyRatesService.fetchCBCurrencyRates { models in
          if !models.isEmpty {
            services.appSettingsDataManager.setAllCurrencyRate(models) {
              semaphore.signal()
            }
          } else {
            semaphore.signal()
          }
        }
      case .ecb:
        services.dataManagementService.currencyRatesService.fetchECBCurrencyRates { models in
          if !models.isEmpty {
            services.appSettingsDataManager.setAllCurrencyRate(models) {
              semaphore.signal()
            }
          } else {
            semaphore.signal()
          }
        }
      }
    }
    
    // Устанавливаем таймаут в 10 секунд и продолжаем выполнение независимо от результата
    _ = semaphore.wait(timeout: .now() + 5)
  }
}

// MARK: - Private

private extension CurrencyRatesConfigurator {}
