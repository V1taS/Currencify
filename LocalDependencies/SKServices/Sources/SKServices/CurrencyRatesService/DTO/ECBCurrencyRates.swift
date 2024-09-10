//
//  ECBCurrencyRates.swift
//  SKServices
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import Foundation

/// Модель для работы с API Европейского Центрального Банка.
/// Содержит дату и список валют по курсу.
struct ECBCurrencyRates {
  /// Дата курса валют в формате `Date`.
  let date: Date
  
  /// Массив валют с курсами.
  let currencies: [Currency]
}

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
  private var currentDate: Date?
  
  private var parserCompletionHandler: ((ECBCurrencyRates?) -> Void)?
  
  init(data: Data) {
    super.init()
    let parser = XMLParser(data: data)
    parser.delegate = self
    parser.parse()
  }
  
  /// Метод для парсинга данных
  func parse() -> ECBCurrencyRates? {
    guard let date = currentDate else { return nil }
    return ECBCurrencyRates(date: date, currencies: currencies)
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
    
    if elementName == "Cube", let time = attributeDict["time"] {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      currentDate = dateFormatter.date(from: time)
    } else if elementName == "Cube", let currency = attributeDict["currency"], let rate = attributeDict["rate"] {
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
