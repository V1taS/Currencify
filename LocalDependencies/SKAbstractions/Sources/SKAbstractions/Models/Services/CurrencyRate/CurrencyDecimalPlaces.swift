//
//  CurrencyDecimalPlaces.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 10.09.2024.
//

import Foundation

/// Перечисление для указания количества десятичных знаков в валютных значениях.
public enum CurrencyDecimalPlaces: Int, CaseIterable {
  /// Без десятичных знаков.
  case zero = 0
  
  /// Один знак после запятой.
  case one = 1
  
  /// Два знака после запятой.
  case two = 2
  
  /// Три знака после запятой.
  case three = 3
  
  /// Четыре знака после запятой.
  case four = 4
  
  /// Пять знаков после запятой.
  case five = 5
}

// MARK: - IdentifiableAndCodable

extension CurrencyDecimalPlaces: IdentifiableAndCodable {}
