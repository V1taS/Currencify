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
  private var currencyRateModels: [CurrencyRate] = []
  
  // MARK: - Private properties
  
  private let appSettingsDataManager = AppSettingsDataManager.shared
  
  // Приватный инициализатор для предотвращения создания других экземпляров
  private init() {}
  
  public func fetchCurrencyRates(_ completion: (() -> Void)?) {
    Task {
      await getApiCurrencyBeacon()
      fetchRatesFromAPIs(at: .zero, completion: completion)
    }
  }
  
  private func fetchRatesFromAPIs(at index: Int, completion: (() -> Void)?) {
    guard index < Secrets.currencyBeaconAPI.count else {
      // Все API были опрошены, завершаем без обновления
      DispatchQueue.main.async {
        completion?()
      }
      return
    }
    
    let beaconApi = Secrets.currencyBeaconAPI[index]
    fetchCurrencyBeaconRates(beaconApi: beaconApi) { [weak self] models in
      guard let self else { return }
      
      if !models.isEmpty {
        // Удаляем дубли по currency
        var uniqueCurrencyRateModels: [CurrencyRate.Currency: CurrencyRate] = [:]
        models.forEach { model in
          uniqueCurrencyRateModels[model.currency] = model
        }
        self.currencyRateModels = Array(uniqueCurrencyRateModels.values)
        
        self.appSettingsDataManager.getAppSettingsModel { [weak self] appSettingsModel in
          guard let self else { return }
          
          if appSettingsModel.currencyTypes.contains(.crypto) {
            self.fetchTopCryptoCurrencyRates(baseCurrency: .RUB) { [weak self] cryptoModels in
              guard let self else { return }
              
              // Удаляем дубли при добавлении криптовалют
              cryptoModels.forEach { model in
                uniqueCurrencyRateModels[model.currency] = model
              }
              self.currencyRateModels = Array(uniqueCurrencyRateModels.values)
              
              self.appSettingsDataManager.setAllCurrencyRate(self.currencyRateModels) {
                DispatchQueue.main.async {
                  completion?()
                }
              }
            }
          } else {
            self.appSettingsDataManager.setAllCurrencyRate(self.currencyRateModels) {
              DispatchQueue.main.async {
                completion?()
              }
            }
          }
        }
      } else {
        // Переходим к следующему API
        self.fetchRatesFromAPIs(at: index + 1, completion: completion)
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
        
        switch currency.details.source {
        case .currency:
          // Для обычных валют
          currencyRates.append(
            CurrencyRate(
              currency: currency,
              rate: invertedRate,
              lastUpdated: lastUpdated
            )
          )
        case .crypto:
          // Для криптовалютой
          let imageURL = getCryptoImageURL(for: code)
          currencyRates.append(
            CurrencyRate(
              currency: currency,
              rate: invertedRate,
              lastUpdated: lastUpdated,
              imageURL: imageURL
            )
          )
        case .stock: break
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
  func fetchCurrencyBeaconRates(beaconApi: String, completion: @escaping ([CurrencyRate]) -> Void) {
    let baseCurrency = CurrencyRate.Currency.RUB.rawValue
    let urlString = "https://api.currencybeacon.com/v1/latest?api_key=\(beaconApi)&base=\(baseCurrency)"
    performRequest(with: urlString, parsingMethod: parseCurrencyBeaconData, completion: completion)
  }
  
  func getCryptoImageURL(for code: String) -> String {
    let lowercasedCode = code.lowercased()
    let imageURL = "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/128/color/\(lowercasedCode).png"
    return imageURL
  }
  
  func getApiCurrencyBeacon() async {
    if let value = await getConfigurationValue(forKey: Constants.apiKeyCurrencyBeacon) {
      guard let jsonData = value.data(using: .utf8) else {
        return
      }
      
      let decoder = JSONDecoder()
      guard let listBeaconAPI = try? decoder.decode([String].self, from: jsonData) else {
        return
      }
      Secrets.currencyBeaconAPI = listBeaconAPI
    }
  }
  
  func getConfigurationValue(forKey key: String) async -> String? {
    await withCheckedContinuation { continuation in
      CloudKitService.shared.getConfigurationValue(from: key) { (result: Result<String?, Error>) in
        if case let .success(value) = result, let value {
          continuation.resume(returning: value)
        } else {
          continuation.resume(returning: nil)
        }
      }
    }
  }
  
  func fetchTopCryptoCurrencyRates(
    baseCurrency: CurrencyRate.Currency,
    completion: @escaping ([CurrencyRate]) -> Void
  ) {
    let vsCurrency = baseCurrency.rawValue.lowercased()
    let perPage = 100
    let page = 1
    let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(vsCurrency)&order=market_cap_desc&per_page=\(perPage)&page=\(page)&sparkline=false"
    
    performRequest(with: urlString, parsingMethod: parseCryptoData) { currencyRates in
      completion(currencyRates)
    }
  }
  
  // Парсинг данных от CoinGecko для криптовалют
  func parseCryptoData(_ data: Data) throws -> [CurrencyRate] {
    let decoder = JSONDecoder()
    let iso8601Formatter = ISO8601DateFormatter()
    iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let dateStr = try container.decode(String.self)
      
      if let date = iso8601Formatter.date(from: dateStr) {
        return date
      }
      
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Невозможно декодировать дату: \(dateStr)"
      )
    }
    
    // Декодирование массива криптовалют
    let cryptoCurrencies = try decoder.decode([CryptoCurrencyRates.CryptoCurrency].self, from: data)
    
    // Преобразование в [CurrencyRate]
    let currencyRates: [CurrencyRate] = cryptoCurrencies.compactMap { crypto in
      guard let currency = CurrencyRate.Currency(rawValue: crypto.symbol.uppercased()) else {
        return nil
      }
      
      return CurrencyRate(
        currency: currency,
        rate: crypto.currentPrice,
        lastUpdated: crypto.lastUpdated,
        imageURL: crypto.image
      )
    }
    
    return currencyRates
  }
}

// MARK: - Constants

private enum Constants {
  static let apiKeyCurrencyBeacon = "currencybeaconAPI"
}
