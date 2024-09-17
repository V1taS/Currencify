//
//  CurrencyRate.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 09.09.2024.
//

import Foundation

public struct CurrencyRate {
  /// Валюта, представленная с помощью перечисления `Currency`.
  public let currency: Currency
  
  /// Текущий курс валюты.
  public let rate: Double
  
  /// Дата последнего обновления курса валюты.
  public let lastUpdated: Date
  
  /// Инициализирует структуру `CurrencyRate` с указанной валютой, курсом и датой обновления.
  /// - Parameters:
  ///  - currency: Валюта, представленная в виде значения перечисления `Currency`.
  ///  - rate: Текущий курс валюты.
  ///  - lastUpdated: Дата последнего обновления курса.
  public init(
    currency: CurrencyRate.Currency,
    rate: Double,
    lastUpdated: Date
  ) {
    self.currency = currency
    self.rate = rate
    self.lastUpdated = lastUpdated
  }
}

// MARK: - Currency

extension CurrencyRate {
  public enum Currency: String {
    /// Канадский доллар
    case CAD
    /// Евро
    case EUR
    /// Бразильский реал
    case BRL
    /// Вьетнамский донг
    case VND
    /// Туркменский манат
    case TMT
    /// Венгерский форинт
    case HUF
    /// Азербайджанский манат
    case AZN
    /// Белорусский рубль
    case BYN
    /// Доллар США
    case USD
    /// Южноафриканский рэнд
    case ZAR
    /// Швейцарский франк
    case CHF
    /// Чешская крона
    case CZK
    /// Новозеландский доллар
    case NZD
    /// Турецкая лира
    case TRY
    /// Японская иена
    case JPY
    /// Катарский риал
    case QAR
    /// Болгарский лев
    case BGN
    /// Сингапурский доллар
    case SGD
    /// Сербский динар
    case RSD
    /// Норвежская крона
    case NOK
    /// Гонконгский доллар
    case HKD
    /// Тайский бат
    case THB
    /// Шведская крона
    case SEK
    /// Молдавский лей
    case MDL
    /// Датская крона
    case DKK
    /// Дирхам ОАЭ
    case AED
    /// Египетский фунт
    case EGP
    /// Южнокорейская вона
    case KRW
    /// Польский злотый
    case PLN
    /// Индонезийская рупия
    case IDR
    /// Китайский юань
    case CNY
    /// Британский фунт стерлингов
    case GBP
    /// Грузинский лари
    case GEL
    /// Украинская гривна
    case UAH
    /// Киргизский сом
    case KGS
    /// Специальные права заимствования (SDR)
    case XDR
    /// Таджикский сомони
    case TJS
    /// Армянский драм
    case AMD
    /// Австралийский доллар
    case AUD
    /// Казахстанский тенге
    case KZT
    /// Румынский лей
    case RON
    /// Узбекский сум
    case UZS
    /// Индийская рупия
    case INR
    /// Российский рубль
    case RUB
    
    /// Возвращает информацию о валюте: её локализованное название, страну и коды (буквенный и цифровой).
    public var details: (
      name: String,
      country: String,
      code: (alpha: String, numeric: String)
    ) {
      switch self {
      case .RUB:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Rub.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Rub.country,
          (
            alpha: "RUB",
            numeric: "643"
          )
        )
      case .CAD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Cad.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Cad.country,
          (
            alpha: "CAD",
            numeric: "124"
          )
        )
      case .EUR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Eur.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Eur.country,
          (
            alpha: "EUR",
            numeric: "978"
          )
        )
      case .BRL:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Brl.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Brl.country,
          (
            alpha: "BRL",
            numeric: "986"
          )
        )
      case .VND:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Vnd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Vnd.country,
          (
            alpha: "VND",
            numeric: "704"
          )
        )
      case .TMT:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Tmt.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Tmt.country,
          (
            alpha: "TMT",
            numeric: "934"
          )
        )
      case .HUF:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Huf.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Huf.country,
          (
            alpha: "HUF",
            numeric: "348"
          )
        )
      case .AZN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Azn.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Azn.country,
          (
            alpha: "AZN",
            numeric: "944"
          )
        )
      case .BYN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Byn.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Byn.country,
          (
            alpha: "BYN",
            numeric: "933"
          )
        )
      case .USD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Usd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Usd.country,
          (
            alpha: "USD",
            numeric: "840"
          )
        )
      case .ZAR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Zar.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Zar.country,
          (
            alpha: "ZAR",
            numeric: "710"
          )
        )
      case .CHF:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Chf.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Chf.country,
          (
            alpha: "CHF",
            numeric: "756"
          )
        )
      case .CZK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Czk.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Czk.country,
          (
            alpha: "CZK",
            numeric: "203"
          )
        )
      case .NZD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Nzd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Nzd.country,
          (
            alpha: "NZD",
            numeric: "554"
          )
        )
      case .TRY:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Try.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Try.country,
          (
            alpha: "TRY",
            numeric: "949"
          )
        )
      case .JPY:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Jpy.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Jpy.country,
          (
            alpha: "JPY",
            numeric: "392"
          )
        )
      case .QAR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Qar.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Qar.country,
          (
            alpha: "QAR",
            numeric: "634"
          )
        )
      case .BGN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Bgn.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Bgn.country,
          (
            alpha: "BGN",
            numeric: "975"
          )
        )
      case .SGD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Sgd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Sgd.country,
          (
            alpha: "SGD",
            numeric: "702"
          )
        )
      case .RSD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Rsd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Rsd.country,
          (
            alpha: "RSD",
            numeric: "941"
          )
        )
      case .NOK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Nok.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Nok.country,
          (
            alpha: "NOK",
            numeric: "578"
          )
        )
      case .HKD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Hkd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Hkd.country,
          (
            alpha: "HKD",
            numeric: "344"
          )
        )
      case .THB:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Thb.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Thb.country,
          (
            alpha: "THB",
            numeric: "764"
          )
        )
      case .SEK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Sek.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Sek.country,
          (
            alpha: "SEK",
            numeric: "752"
          )
        )
      case .MDL:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Mdl.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Mdl.country,
          (
            alpha: "MDL",
            numeric: "498"
          )
        )
      case .DKK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Dkk.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Dkk.country,
          (
            alpha: "DKK",
            numeric: "208"
          )
        )
      case .AED:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Aed.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Aed.country,
          (
            alpha: "AED",
            numeric: "784"
          )
        )
      case .EGP:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Egp.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Egp.country,
          (
            alpha: "EGP",
            numeric: "818"
          )
        )
      case .KRW:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Krw.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Krw.country,
          (
            alpha: "KRW",
            numeric: "410"
          )
        )
      case .PLN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Pln.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Pln.country,
          (
            alpha: "PLN",
            numeric: "985"
          )
        )
      case .IDR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Idr.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Idr.country,
          (
            alpha: "IDR",
            numeric: "360"
          )
        )
      case .CNY:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Cny.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Cny.country,
          (
            alpha: "CNY",
            numeric: "156"
          )
        )
      case .GBP:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Gbp.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Gbp.country,
          (
            alpha: "GBP",
            numeric: "826"
          )
        )
      case .GEL:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Gel.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Gel.country,
          (
            alpha: "GEL",
            numeric: "981"
          )
        )
      case .UAH:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Uah.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Uah.country,
          (
            alpha: "UAH",
            numeric: "980"
          )
        )
      case .KGS:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Kgs.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Kgs.country,
          (
            alpha: "KGS",
            numeric: "417"
          )
        )
      case .XDR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Xdr.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Xdr.country,
          (
            alpha: "XDR",
            numeric: "960"
          )
        )
      case .TJS:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Tjs.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Tjs.country,
          (
            alpha: "TJS",
            numeric: "972"
          )
        )
      case .AMD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Amd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Amd.country,
          (
            alpha: "AMD",
            numeric: "051"
          )
        )
      case .AUD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Aud.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Aud.country,
          (
            alpha: "AUD",
            numeric: "036"
          )
        )
      case .KZT:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Kzt.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Kzt.country,
          (
            alpha: "KZT",
            numeric: "398"
          )
        )
      case .RON:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Ron.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Ron.country,
          (
            alpha: "RON",
            numeric: "946"
          )
        )
      case .UZS:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Uzs.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Uzs.country,
          (
            alpha: "UZS",
            numeric: "860"
          )
        )
      case .INR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Inr.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Inr.country,
          (
            alpha: "INR",
            numeric: "356"
          )
        )
      }
    }
    
  }
}

// MARK: - CalculateAmountsRelativeTo

extension CurrencyRate {
  /// Рассчитывает курсы валют относительно заданной валюты.
  ///
  /// Метод принимает исходную валюту и количество, а затем вычисляет курсы для всех валют
  /// в зависимости от выбранного режима расчета (`RateCalculationMode`).
  ///
  /// - Parameters:
  ///   - valueCurrency: Валюта, относительно которой будет выполняться расчет.
  ///   - amount: Количество исходной валюты для конвертации.
  ///   - calculationMode: Режим расчета, определяющий, как производить пересчет (прямой или обратный).
  ///   - allCurrencyRate: Список всех валют
  /// - Returns: Массив валют с пересчитанными курсами, либо пустой массив, если исходная валюта не найдена.
  public static func calculateCurrencyRates(
    from valueCurrency: CurrencyRate.Currency,
    amount: Double,
    calculationMode: RateCalculationMode,
    allCurrencyRate: [CurrencyRate]
  ) -> [CurrencyRate] {
    let allCurrency = allCurrencyRate
    guard let targetCurrency = allCurrency.first(where: { $0.currency == valueCurrency }) else {
      return []
    }
    return allCurrency.compactMap {
      convert(amount, from: targetCurrency, to: $0, calculationMode: calculationMode)
    }
  }
  
  private static func convert(
    _ value: Double,
    from valueCurrency: CurrencyRate,
    to outputCurrency: CurrencyRate,
    calculationMode: RateCalculationMode
  ) -> CurrencyRate {
    let valueRate = valueCurrency.rate
    let outputRate = outputCurrency.rate
    
    let resultRate: Double
    switch calculationMode {
    case .direct:
      // Прямой расчет: сколько единиц outputCurrency можно купить за value единиц valueCurrency
      let multiplier = outputRate / valueRate
      resultRate = value * multiplier
    case .inverse:
      // Обратный расчет: сколько единиц valueCurrency нужно для покупки value единиц outputCurrency
      let multiplier = valueRate / outputRate
      resultRate = value * multiplier
    }
    
    return CurrencyRate(
      currency: outputCurrency.currency,
      rate: resultRate,
      lastUpdated: outputCurrency.lastUpdated
    )
  }
}

// MARK: - CalculateRatesRelativeTo

extension CurrencyRate {
  public func emojiFlag() -> String? {
    let trimmedCountryCode = String(currency.details.code.alpha.prefix(2))
    guard trimmedCountryCode.count == 2 else {
      return nil
    }
    
    let regionalIndicatorStartIndex: UInt32 = 0x1F1E6
    let alphabetOffset = UnicodeScalar(unicodeScalarLiteral: "A").value
    return String(trimmedCountryCode
      .uppercased()
      .unicodeScalars
      .compactMap { UnicodeScalar(
        regionalIndicatorStartIndex + ($0.value - alphabetOffset)
      )}
      .map { Character($0) }
    )
  }
}

// MARK: - IdentifiableAndCodable

extension CurrencyRate: IdentifiableAndCodable {}
extension CurrencyRate.Currency: IdentifiableAndCodable {}
