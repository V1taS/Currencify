//
//  AppSettingsDataManager.swift
//  SKServices
//
//  Created by Vitalii Sosin on 06.06.2024.
//

import Foundation
import SwiftUI
import SKAbstractions
import SKStyle

// MARK: - AppSettingsDataManager

public final class AppSettingsDataManager: IAppSettingsDataManager {
  
  // MARK: - Public properties
  
  public static let shared = AppSettingsDataManager()
  
  // MARK: - Private properties
  
  private var appSettingsData = SecureDataManagerService(.appSettingsData)
  private let queueAppSettings = DispatchQueue(label: "com.sosinvitalii.AppSettingsDataQueue")
  
  // MARK: - Init
  
  private init() {}
  
  public func getAppSettingsModel(completion: @escaping (AppSettingsModel) -> Void) {
    queueAppSettings.async { [weak self] in
      guard let self = self else { return }
      let messengerModel: AppSettingsModel
      if let model: AppSettingsModel? = self.appSettingsData.getModel(for: Constants.appSettingsManagerKey),
         let unwrappedModel = model {
        messengerModel = unwrappedModel
      } else {
        messengerModel = AppSettingsModel.setDefaultValues()
      }
      completion(messengerModel)
    }
  }
  
  public func saveAppSettingsModel(_ model: AppSettingsModel, completion: @escaping () -> Void) {
    queueAppSettings.async { [weak self] in
      guard let self = self else { return }
      self.appSettingsData.saveModel(model, for: Constants.appSettingsManagerKey)
      completion()
    }
  }
  
  @discardableResult
  public func deleteAllData() -> Bool {
    appSettingsData.deleteAllData()
  }
  
  public func setIsPremiumEnabled(_ value: Bool, completion: @escaping () -> Void) {
    getAppSettingsModel { [weak self] model in
      var updatedModel = model
      updatedModel.isPremium = value
      self?.saveAppSettingsModel(updatedModel, completion: completion)
    }
  }
  
  public func setCurrencySource(_ value: CurrencySource, completion: @escaping () -> Void) {
    getAppSettingsModel { [weak self] model in
      var updatedModel = model
      updatedModel.currencySource = value
      self?.saveAppSettingsModel(updatedModel, completion: completion)
    }
  }
  
  public func setCurrencyDecimalPlaces(_ value: CurrencyDecimalPlaces, completion: @escaping () -> Void) {
    getAppSettingsModel { [weak self] model in
      var updatedModel = model
      updatedModel.currencyDecimalPlaces = value
      self?.saveAppSettingsModel(updatedModel, completion: completion)
    }
  }
  
  public func setSelectedCurrencyRates(
    _ currencyRates: [CurrencyRate.Currency],
    completion: @escaping () -> Void
  ) {
    getAppSettingsModel { [weak self] model in
      var updatedModel = model
      let newCurrencyRates = currencyRates.filter { !updatedModel.selectedCurrencyRate.contains($0) }
      updatedModel.selectedCurrencyRate.append(contentsOf: newCurrencyRates)
      self?.saveAppSettingsModel(updatedModel, completion: completion)
    }
  }
  
  public func removeCurrencyRates(
    _ currencyRates: [CurrencyRate.Currency],
    completion: @escaping () -> Void
  ) {
    getAppSettingsModel { [weak self] model in
      var updatedModel = model
      updatedModel.selectedCurrencyRate.removeAll { currencyRates.contains($0) }
      self?.saveAppSettingsModel(updatedModel, completion: completion)
    }
  }
  
  public func removeAllCurrencyRates(
    completion: @escaping () -> Void
  ) {
    getAppSettingsModel { [weak self] model in
      var updatedModel = model
      updatedModel.selectedCurrencyRate.removeAll()
      self?.saveAppSettingsModel(updatedModel, completion: completion)
    }
  }
}

// MARK: - Constants

private enum Constants {
  static let appSettingsManagerKey = String(describing: AppSettingsDataManager.self)
}
