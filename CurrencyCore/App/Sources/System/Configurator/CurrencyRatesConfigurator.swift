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
      switch appSettingsModel.centralBanks {
      case .centralBankOfRussia:
        services.dataManagementService.currencyRatesService.fetchCBCurrencyRates { rateDic in
          services.appSettingsDataManager.setCentralBanks(.centralBankOfRussia(rateDic)) {
            semaphore.signal()
          }
        }
      case .europeanCentralBank:
        services.dataManagementService.currencyRatesService.fetchECBCurrencyRates { rateDic in
          services.appSettingsDataManager.setCentralBanks(.europeanCentralBank(rateDic)) {
            semaphore.signal()
          }
        }
      }
    }
    semaphore.wait()
  }
}

// MARK: - Private

private extension CurrencyRatesConfigurator {}
