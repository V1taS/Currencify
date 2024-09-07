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
  /// - Returns: Асинхронная операция, возвращающая модель настроек `AppSettingsModel`
  func getAppSettingsModel() async -> AppSettingsModel
  
  /// Сохранить модель настроек приложения
  /// - Parameter model: Модель настроек `AppSettingsModel`, которую необходимо сохранить
  func saveAppSettingsModel(_ model: AppSettingsModel) async
  
  /// Удалить все данные настроек приложения
  /// - Returns: Возвращает `true`, если данные успешно удалены
  @discardableResult
  func deleteAllData() -> Bool
  
  /// Установить статус подписки на премиум
  /// - Parameter value: Булево значение, указывающее, включен ли премиум
  func setIsPremiumEnabled(_ value: Bool) async
}
