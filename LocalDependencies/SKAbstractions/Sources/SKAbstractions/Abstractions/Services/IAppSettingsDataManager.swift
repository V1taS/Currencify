//
//  IAppSettingsManager.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 18.05.2024.
//

import Foundation

/// Работа с настройками приложения
public protocol IAppSettingsDataManager {
  
  /// Получить модель настроек приложения
  /// - Parameter completion: Замыкание, которое будет вызвано после получения данных. Возвращает модель настроек `AppSettingsModel`
  func getAppSettingsModel(completion: @escaping (AppSettingsModel) -> Void)
  
  /// Сохранить модель настроек приложения
  /// - Parameters:
  ///   - model: Модель настроек `AppSettingsModel`, которую необходимо сохранить
  ///   - completion: Замыкание, которое будет вызвано после завершения сохранения
  func saveAppSettingsModel(_ model: AppSettingsModel, completion: @escaping () -> Void)
  
  /// Удалить все данные настроек приложения
  /// - Returns: Возвращает `true`, если данные успешно удалены
  @discardableResult
  func deleteAllData() -> Bool
  
  /// Установить статус подписки на премиум
  /// - Parameters:
  ///   - value: Булево значение, указывающее, включен ли премиум
  ///   - completion: Замыкание, которое будет вызвано после обновления статуса премиум
  func setIsPremiumEnabled(_ value: Bool, completion: @escaping () -> Void)
  
  /// Установить модель центральных банков
  /// - Parameters:
  ///   - centralBanks: Модель `CentralBanks`, содержащая данные о центральных банках
  ///   - completion: Замыкание, которое будет вызвано после завершения сохранения данных центральных банков
  func setCentralBanks(_ centralBanks: CentralBanks, completion: @escaping () -> Void)
}
