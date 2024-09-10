//
//  CurrencySource.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 09.09.2024.
//

import Foundation

/// Источник курсов валют
/// - `cbr`: Центробанк России
/// - `ecb`: Европейский Центральный Банк
public enum CurrencySource {
  
  /// Центробанк России
  case cbr
  
  /// Европейский Центральный Банк
  case ecb
  
  /// Описание источника
  /// Возвращает краткое текстовое описание для каждого из источников.
  public var description: String {
    switch self {
    case .cbr:
      return SKAbstractionsStrings.CurrencySource.cbr
    case .ecb:
      return SKAbstractionsStrings.CurrencySource.ecb
    }
  }
}

// MARK: - Set default values

extension CurrencySource: IdentifiableAndCodable {}
