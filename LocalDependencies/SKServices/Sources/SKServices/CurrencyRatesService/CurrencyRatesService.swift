//
//  CurrencyRatesService.swift
//  SKServices
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import SwiftUI
import SKAbstractions
import SKStyle
import CoreImage.CIFilterBuiltins
import SKFoundation

// MARK: - CurrencyRatesService

public final class CurrencyRatesService: ICurrencyRatesService {
  
  // MARK: - Singleton
  
  public static let shared = CurrencyRatesService()
  
  // MARK: - Private properties
  
  private let appSettingsDataManager = AppSettingsDataManager.shared
  
  // Приватный инициализатор для предотвращения создания других экземпляров
  private init() {}
  
  public func fetchCurrencyRates(_ completion: (() -> Void)?) {
    var currencyRateModels: [CurrencyRate] = []
    
    appSettingsDataManager.getAppSettingsModel { [weak self] appSettingsModel in
      guard let self else { return }
      
      fetchCurrencyBeaconRates { [weak self] models in
        guard let self else { return }
        currencyRateModels = models
        
        self.appSettingsDataManager.setAllCurrencyRate(currencyRateModels) {
          completion?()
        }
      }
    }
  }
}

// MARK: - Private

private extension CurrencyRatesService {
  // Создание сессии для запросов
  func createSession() -> URLSession {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 30
    return URLSession(configuration: config)
  }
  
  // Метод для выполнения сетевого запроса
  func performRequest(
    with urlString: String,
    parsingMethod: @escaping (Data) throws -> [CurrencyRate],
    completion: @escaping ([CurrencyRate]) -> Void
  ) {
    guard let url = URL(string: urlString) else {
      print("Ошибка: Некорректный URL - \(urlString)")
      completion([])
      return
    }
    
    let task = createSession().dataTask(with: url) { data, response, error in
      if let error = error {
        print("Ошибка при выполнении запроса: \(error.localizedDescription)")
        completion([])
        return
      }
      
      guard let data = data else {
        print("Ошибка: Отсутствуют данные в ответе")
        completion([])
        return
      }
      
      do {
        let parsedData = try parsingMethod(data)
        completion(parsedData)
      } catch {
        print("Ошибка при парсинге данных: \(error.localizedDescription)")
        completion([])
      }
    }
    task.resume()
  }
  
  // Парсинг данных от CurrencyBeacon
  func parseCurrencyBeaconData(_ data: Data) throws -> [CurrencyRate] {
    // Модели для парсинга JSON
    struct CurrencyBeaconRoot: Codable {
      let meta: Meta
      let response: CurrencyBeaconResponse
    }
    
    struct Meta: Codable {
      let code: Int
      let disclaimer: String
    }
    
    struct CurrencyBeaconResponse: Codable {
      let date: String // Пример: "2024-11-28T16:00:23Z"
      let base: String
      let rates: [String: Double]
    }
    
    let decoder = JSONDecoder()
    let root = try decoder.decode(CurrencyBeaconRoot.self, from: data)
    let response = root.response
    
    // Парсим дату из строки в Date
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime]
    guard let lastUpdated = dateFormatter.date(from: response.date) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: [],
          debugDescription: "Неверный формат даты: \(response.date)"
        )
      )
    }
    
    var currencyRates: [CurrencyRate] = []
    
    // Удаляем базовую валюту из словаря rates
    var rates = response.rates
    rates.removeValue(forKey: response.base)
    
    // Проходим по оставшимся валютам и инвертируем курсы
    for (code, rate) in rates {
      if let currency = CurrencyRate.Currency(rawValue: code) {
        guard rate != 0 else { continue } // Избегаем деления на ноль
        let invertedRate = 1 / rate
        
        // Проверяем, является ли валюта криптовалютой
        if currency.details.source == .crypto {
          // Получаем URL изображения для криптовалюты
          let imageURL = getCryptoImageURL(for: code)
          
          currencyRates.append(
            CurrencyRate(
              currency: currency,
              rate: invertedRate,
              lastUpdated: lastUpdated,
              imageURL: imageURL
            )
          )
        } else {
          // Для обычных валют оставляем imageURL пустым
          currencyRates.append(
            CurrencyRate(
              currency: currency,
              rate: invertedRate,
              lastUpdated: lastUpdated
            )
          )
        }
      }
    }
    
    // Добавляем базовую валюту с курсом 1.0
    if let baseCurrency = CurrencyRate.Currency(rawValue: response.base) {
      currencyRates.append(
        CurrencyRate(
          currency: baseCurrency,
          rate: 1.0,
          lastUpdated: lastUpdated
        )
      )
    }
    
    return currencyRates
  }
  
  // Запрос курсов валют от CurrencyBeacon
  func fetchCurrencyBeaconRates(completion: @escaping ([CurrencyRate]) -> Void) {
    let baseCurrency = CurrencyRate.Currency.RUB.rawValue
    let apiKey = "5tEsWqbrIgC1F7jz84F2XwhV89DBGm1z"
    let urlString = "https://api.currencybeacon.com/v1/latest?api_key=\(apiKey)&base=\(baseCurrency)"
    performRequest(with: urlString, parsingMethod: parseCurrencyBeaconData, completion: completion)
  }
  
  func getCryptoImageURL(for code: String) -> String {
    let lowercasedCode = code.lowercased()
    let imageURL = "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/\(lowercasedCode).png"
    return imageURL
  }
}
