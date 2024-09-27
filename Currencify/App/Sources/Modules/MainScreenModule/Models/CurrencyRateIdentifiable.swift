//
//  CurrencyRateIdentifiable.swift
//  Currencify
//
//  Created by Vitalii Sosin on 24.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct CurrencyRateIdentifiable: Identifiable {
  let id: UUID
  let currency: CurrencyRate.Currency
  let imageURL: URL?
  let rateText: String
  let rateDouble: Double
  
  init(
    currency: CurrencyRate.Currency,
    imageURL: URL?,
    rateText: String,
    rateDouble: Double
  ) {
    id = UUID()
    self.currency = currency
    self.imageURL = imageURL
    self.rateText = rateText
    self.rateDouble = rateDouble
  }
}
