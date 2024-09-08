//
//  AppSettingsModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 17.05.2024.
//

import Foundation

/// Модель, представляющая настройки приложения.
public struct AppSettingsModel {
  
  public var isPremium: Bool
  public var centralBanks: CentralBanks
  
  /// Инициализирует новый экземпляр `AppSettingsModel`
  /// - Parameters:
  ///   - isPremium: Премиум режим
  ///   - centralBanks: Банк с курсами валют
  public init(
    isPremium: Bool,
    centralBanks: CentralBanks
  ) {
    self.isPremium = isPremium
    self.centralBanks = centralBanks
  }
}

// MARK: - Set default values

extension AppSettingsModel {
  public static func setDefaultValues() -> Self {
    return .init(
      isPremium: false,
      centralBanks: .centralBankOfRussia([:])
    )
  }
}

// MARK: - IdentifiableAndCodable

extension AppSettingsModel: IdentifiableAndCodable {}
