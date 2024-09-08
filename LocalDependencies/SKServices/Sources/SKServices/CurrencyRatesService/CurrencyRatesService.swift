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
  
  // Создание сессии для запросов
  private func createSession() -> URLSession {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 10
    config.timeoutIntervalForResource = 10
    return URLSession(configuration: config)
  }
  
  // Запрос курсов валют от Центробанка России
  public func fetchCBCurrencyRates(completion: @escaping ([String: Double]) -> Void) {
    let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    
    guard let url = URL(string: urlString) else {
      completion([:])
      return
    }
    
    let task = createSession().dataTask(with: url) { data, _, error in
      if error != nil {
        completion([:])
        return
      }
      
      guard let data = data else {
        completion([:])
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let cbrResponse = try decoder.decode(CBCurrencyRates.CBRResponse.self, from: data)
        let currencies = Array(cbrResponse.valute.values)
        let dictionary = Dictionary(uniqueKeysWithValues: currencies.compactMap { ($0.charCode, $0.value) })
        completion(dictionary)
      } catch {
        completion([:])
      }
    }
    task.resume()
  }
  
  // Запрос курсов валют от Европейского Центробанка
  public func fetchECBCurrencyRates(completion: @escaping ([String: Double]) -> Void) {
    let urlString = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    
    guard let url = URL(string: urlString) else {
      completion([:])
      return
    }
    
    let task = createSession().dataTask(with: url) { data, _, error in
      if error != nil {
        completion([:])
        return
      }
      
      guard let data = data else {
        completion([:])
        return
      }
      
      let parser = ECBXMLParser(data: data)
      let currencies = parser.parse()
      let dictionary = Dictionary(uniqueKeysWithValues: currencies.compactMap { ($0.code, $0.rate) })
      completion(dictionary)
    }
    task.resume()
  }
}
