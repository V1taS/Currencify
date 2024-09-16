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
  
  // Приватный инициализатор для предотвращения создания других экземпляров
  private init() {}
  
  // Запрос курсов валют от Центробанка России
  public func fetchCBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void) {
    let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    performRequest(with: urlString, parsingMethod: parseCBRData, completion: completion)
  }
  
  // Запрос курсов валют от Европейского Центрального Банка
  public func fetchECBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void) {
    let urlString = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    performRequest(with: urlString, parsingMethod: parseECBData, completion: completion)
  }
}

// MARK: - Private

private extension CurrencyRatesService {
  // Создание сессии для запросов
  func createSession() -> URLSession {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 10
    config.timeoutIntervalForResource = 10
    return URLSession(configuration: config)
  }
  
  // Метод для выполнения сетевого запроса
  func performRequest(
    with urlString: String,
    parsingMethod: @escaping (Data) throws -> [CurrencyRate],
    completion: @escaping ([CurrencyRate]) -> Void
  ) {
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }
    
    let task = createSession().dataTask(with: url) { data, _, error in
      if error != nil {
        completion([])
        return
      }
      
      guard let data = data else {
        completion([])
        return
      }
      
      do {
        let parsedData = try parsingMethod(data)
        completion(parsedData)
      } catch {
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
    
    // Добавить евро с рассчитанным направлением изменения курса
    currencyModels.append(
      .init(
        currency: .EUR,
        rate: 1,
        lastUpdated: ecbData.date
      )
    )
    return currencyModels
  }
}
