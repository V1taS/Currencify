//
//  ECBCurrencyRates.swift
//  SKServices
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Модель для работы с API Европейского Центрального Банка.
/// Содержит метод для получения списка валют по курсу.
struct ECBCurrencyRates {}

/// Расширение для модели, связанное с валютами.
extension ECBCurrencyRates {
  
  /// Модель валюты, возвращаемой ЕЦБ.
  struct Currency: Codable {
    /// Код валюты (например, USD).
    let code: String
    
    /// Курс валюты относительно евро.
    let rate: Double
  }
}

/// Парсер XML данных от ЕЦБ.
final class ECBXMLParser: NSObject, XMLParserDelegate {
  private var currencies: [ECBCurrencyRates.Currency] = []
  private var currentElement = ""
  private var currentCurrencyCode: String = ""
  private var currentCurrencyRate: Double = 0.0
  
  private var parserCompletionHandler: (([ECBCurrencyRates.Currency]) -> Void)?
  
  init(data: Data) {
    super.init()
    let parser = XMLParser(data: data)
    parser.delegate = self
    parser.parse()
  }
  
  func parse() -> [ECBCurrencyRates.Currency] {
    return currencies
  }
  
  // MARK: - XMLParserDelegate Methods
  
  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String: String] = [:]
  ) {
    currentElement = elementName
    if elementName == "Cube", let currency = attributeDict["currency"], let rate = attributeDict["rate"] {
      currentCurrencyCode = currency
      currentCurrencyRate = Double(rate) ?? 0.0
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "Cube", !currentCurrencyCode.isEmpty {
      let currency = ECBCurrencyRates.Currency(code: currentCurrencyCode, rate: currentCurrencyRate)
      currencies.append(currency)
    }
  }
}

