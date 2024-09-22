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
  func setSelectedCurrencyRates(_ currencyRates: [CurrencyRate.Currency], completion: @escaping () -> Void)
  
  /// Добавляет все валюты в список
  /// - Parameters:
  ///   - currencyRates: Массив валют для добавления.
  ///   - completion: Замыкание, которое будет вызвано после завершения операции.
  func setAllCurrencyRate(_ currencyRates: [CurrencyRate], completion: @escaping () -> Void)
  
  /// Удаляет указанные валюты из списка выбранных.
  /// - Parameters:
  ///   - currencyRates: Массив валют для удаления.
  ///   - completion: Замыкание, которое будет вызвано после завершения операции.
  func removeCurrencyRates(_ currencyRates: [CurrencyRate.Currency], completion: @escaping () -> Void)
  
  /// Удаляет все выбранные валюты из списка.
  /// - Parameter completion: Замыкание, которое будет вызвано после завершения операции.
  func removeAllCurrencyRates(completion: @escaping () -> Void)
  
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
  
  /// Устанавливает введённую сумму валюты.
  /// - Parameters:
  ///   - value: Строка, представляющая введённую сумму валюты.
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func setEnteredCurrencyAmount(_ value: Double, completion: @escaping () -> Void)
  
  /// Устанавливает активную валюту для отображения курсов.
  /// - Parameters:
  ///   - value: Валюта, которая будет установлена как активная.
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func setActiveCurrency(_ value: CurrencyRate.Currency, completion: @escaping () -> Void)
  
  /// Устанавливает список с премиум клиентами
  /// - Parameters:
  ///   - premiumList: Список премиум клиентов
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func setPremiumList(_ premiumList: [PremiumModel], completion: @escaping () -> Void)
  
  /// Устанавливает типы валют.
  /// - Parameters:
  ///   - currencyTypes: Массив типов валют, которые будут установлены.
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func setCurrencyTypes(_ currencyTypes: [CurrencyRate.CurrencyType], completion: @escaping () -> Void)
  
  /// Удаляет типы валют.
  /// - Parameters:
  ///   - currencyTypes: Массив типов валют, которые будут удалены.
  ///   - completion: Замыкание, которое вызывается после завершения операции.
  func removeCurrencyTypes(_ currencyTypes: [CurrencyRate.CurrencyType], completion: @escaping () -> Void)
}
