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
  
  /// Добавляет указанные валюты в список выбранных, если они ещё не добавлены.
  /// - Parameters:
  ///   - currencyRates: Массив валют для добавления.
  ///   - completion: Замыкание, которое будет вызвано после завершения операции.
  func setSelectedCurrencyRates(
    _ currencyRates: [CurrencyRate.Currency],
    completion: @escaping () -> Void
  )
  
  /// Удаляет указанные валюты из списка выбранных.
  /// - Parameters:
  ///   - currencyRates: Массив валют для удаления.
  ///   - completion: Замыкание, которое будет вызвано после завершения операции.
  func removeCurrencyRates(
    _ currencyRates: [CurrencyRate.Currency],
    completion: @escaping () -> Void
  )
  
  /// Удаляет все выбранные валюты из списка.
  /// - Parameter completion: Замыкание, которое будет вызвано после завершения операции.
  func removeAllCurrencyRates(
    completion: @escaping () -> Void
  )
  
  /// Устанавливает источник валютных данных.
  /// - Параметры:
  ///   - value: Источник валюты, который необходимо установить.
  ///   - completion: Блок, который будет вызван после успешной установки источника.
  func setCurrencySource(_ value: CurrencySource, completion: @escaping () -> Void)
  
  /// Устанавливает количество знаков после запятой для отображения валютных значений.
  /// - Parameters:
  ///   - value: Значение из перечисления `CurrencyDecimalPlaces`, определяющее количество знаков после запятой (от 0 до 5).
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func setCurrencyDecimalPlaces(_ value: CurrencyDecimalPlaces, completion: @escaping () -> Void)
  
  /// Устанавливает корекцию текущего курса в процентах
  /// - Parameters:
  ///   - value: Значение корректировки в проценте
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func setRateCorrectionPercentage(_ value: Double, completion: @escaping () -> Void)
}
