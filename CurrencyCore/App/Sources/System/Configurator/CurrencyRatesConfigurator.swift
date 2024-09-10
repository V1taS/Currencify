//
//  CurrencyRatesConfigurator.swift
//  CurrencyCore
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
    let semaphore = DispatchSemaphore(value: .zero)
    
    services.appSettingsDataManager.getAppSettingsModel { appSettingsModel in
      switch appSettingsModel.currencySource {
      case .cbr:
        services.dataManagementService.currencyRatesService.fetchCBCurrencyRates { models in
          Secrets.currencyRateList = models
          semaphore.signal()
        }
      case .ecb:
        services.dataManagementService.currencyRatesService.fetchECBCurrencyRates { models in
          Secrets.currencyRateList = models
          semaphore.signal()
        }
      }
    }
    semaphore.wait()
  }
}

// MARK: - Private

private extension CurrencyRatesConfigurator {}
