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
  
  // MARK: - Private properies
  
  private let appSettingsDataManager = AppSettingsDataManager.shared
  
  // Приватный инициализатор для предотвращения создания других экземпляров
  private init() {}
  
  public func fetchCurrencyRates(_ completion: (() -> Void)?) {
    var currencyRateModels: [CurrencyRate] = []
    
    appSettingsDataManager.getAppSettingsModel { [weak self] appSettingsModel in
      guard let self else { return }
      
      fetchCBCurrencyRates { [weak self] models in
        guard let self else { return }
        
        if !models.isEmpty {
          currencyRateModels = models
          
          if appSettingsModel.currencyTypes.contains(.crypto) {
            fetchTopCryptoCurrencyRates(baseCurrency: .RUB) { [weak self] models in
              guard let self else { return }
              
              currencyRateModels.append(contentsOf: models)
              appSettingsDataManager.setAllCurrencyRate(currencyRateModels) {
                completion?()
              }
            }
          } else {
            appSettingsDataManager.setAllCurrencyRate(currencyRateModels) {
              completion?()
            }
          }
        } else {
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
  
  // Парсинг данных от Центробанка России с учётом номинала
  func parseCBRData(_ data: Data) throws -> [CurrencyRate] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let cbrResponse = try decoder.decode(CBCurrencyRates.CBRResponse.self, from: data)
    let currencies = Array(cbrResponse.valute.values)
    
    var currencyModels: [CurrencyRate] = currencies.compactMap {
      guard let currency = CurrencyRate.Currency(rawValue: $0.charCode) else {
        return nil
      }
      // Нормализуем курс, деля Value на Nominal
      let normalizedRate = $0.value / Double($0.nominal)
      return CurrencyRate(
        currency: currency,
        rate: normalizedRate,
        lastUpdated: cbrResponse.date
      )
    }
    
    // Добавить рубль с курсом 1
    currencyModels.append(
      .init(
        currency: .RUB,
        rate: 1.0,
        lastUpdated: cbrResponse.date
      )
    )
    return currencyModels
  }
  
  // Парсинг данных от Европейского Центрального Банка
  func parseECBData(_ data: Data) throws -> [CurrencyRate] {
    let parser = ECBXMLParser(data: data)
    let ecbData = parser.parse()
    
    guard let ecbData else { return [] }
    var currencyModels: [CurrencyRate] = ecbData.currencies.compactMap {
      guard let currency = CurrencyRate.Currency(rawValue: $0.code) else {
        return nil
      }
      return CurrencyRate(
        currency: currency,
        rate: $0.rate,
        lastUpdated: ecbData.date
      )
    }
    
    // Добавить евро с курсом 1
    currencyModels.append(
      .init(
        currency: .EUR,
        rate: 1,
        lastUpdated: ecbData.date
      )
    )
    return currencyModels
  }
  
  func parseCryptoData(_ data: Data) throws -> [CurrencyRate] {
    let decoder = JSONDecoder()
    // Настройка формата даты с поддержкой миллисекунд
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
  
  // Запрос курсов валют от Центробанка России
  func fetchCBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void) {
    let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    performRequest(with: urlString, parsingMethod: parseCBRData, completion: completion)
  }
  
  // Запрос курсов валют от Европейского Центрального Банка
  func fetchECBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void) {
    let urlString = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    performRequest(with: urlString, parsingMethod: parseECBData, completion: completion)
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
}
