//
//  CurrencyRates.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Перечисление, представляющее основные центральные банки.
public enum CentralBanks {
  /// Центральный банк России (ЦБ РФ).
  case centralBankOfRussia([String: Double])
  
  /// Европейский центральный банк (ЕЦБ).
  case europeanCentralBank([String: Double])
  
  public static func == (lhs: CentralBanks, rhs: CentralBanks) -> Bool {
    switch (lhs, rhs) {
    case (.centralBankOfRussia, .centralBankOfRussia),
      (.europeanCentralBank, .europeanCentralBank):
      return true
    default:
      return false
    }
  }
}

// MARK: - IdentifiableAndCodable

extension CentralBanks: IdentifiableAndCodable {}
