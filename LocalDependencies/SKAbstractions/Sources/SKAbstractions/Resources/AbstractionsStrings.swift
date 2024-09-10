import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum SKAbstractionsStrings {
  public enum CurrencySource {
    /// Central Bank of Russia
    public static let cbr = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CurrencySource.CBR")
    /// European Central Bank
    public static let ecb = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CurrencySource.ECB")
  }
  
  public enum CurrencyModelLocalization {
    public enum Aed {
      /// UAE Dirham
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AED.Name")
      /// United Arab Emirates
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AED.Country")
    }
    
    public enum Amd {
      /// Armenian Dram
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AMD.Name")
      /// Armenia
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AMD.Country")
    }
    
    public enum Aud {
      /// Australian Dollar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AUD.Name")
      /// Australia
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AUD.Country")
    }
    
    public enum Azn {
      /// Azerbaijani Manat
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AZN.Name")
      /// Azerbaijan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "AZN.Country")
    }
    
    public enum Bgn {
      /// Bulgarian Lev
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "BGN.Name")
      /// Bulgaria
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "BGN.Country")
    }
    
    public enum Brl {
      /// Brazilian Real
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "BRL.Name")
      /// Brazil
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "BRL.Country")
    }
    
    public enum Byn {
      /// Belarusian Ruble
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "BYN.Name")
      /// Belarus
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "BYN.Country")
    }
    
    public enum Cad {
      /// Canadian Dollar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CAD.Name")
      /// Canada
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CAD.Country")
    }
    
    public enum Chf {
      /// Swiss Franc
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CHF.Name")
      /// Switzerland
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CHF.Country")
    }
    
    public enum Cny {
      /// Chinese Yuan
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CNY.Name")
      /// China
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CNY.Country")
    }
    
    public enum Czk {
      /// Czech Koruna
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CZK.Name")
      /// Czech Republic
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "CZK.Country")
    }
    
    public enum Dkk {
      /// Danish Krone
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "DKK.Name")
      /// Denmark
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "DKK.Country")
    }
    
    public enum Egp {
      /// Egyptian Pound
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "EGP.Name")
      /// Egypt
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "EGP.Country")
    }
    
    public enum Eur {
      /// Euro
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "EUR.Name")
      /// European Union
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "EUR.Country")
    }
    
    public enum Gbp {
      /// British Pound Sterling
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "GBP.Name")
      /// United Kingdom
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "GBP.Country")
    }
    
    public enum Gel {
      /// Georgian Lari
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "GEL.Name")
      /// Georgia
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "GEL.Country")
    }
    
    public enum Hkd {
      /// Hong Kong Dollar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "HKD.Name")
      /// Hong Kong
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "HKD.Country")
    }
    
    public enum Huf {
      /// Hungarian Forint
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "HUF.Name")
      /// Hungary
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "HUF.Country")
    }
    
    public enum Idr {
      /// Indonesian Rupiah
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "IDR.Name")
      /// Indonesia
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "IDR.Country")
    }
    
    public enum Inr {
      /// Indian Rupee
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "INR.Name")
      /// India
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "INR.Country")
    }
    
    public enum Jpy {
      /// Japanese Yen
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "JPY.Name")
      /// Japan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "JPY.Country")
    }
    
    public enum Krw {
      /// South Korean Won
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "KRW.Name")
      /// South Korea
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "KRW.Country")
    }
    
    public enum Kgs {
      /// Kyrgyzstani Som
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "KGS.Name")
      /// Kyrgyzstan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "KGS.Country")
    }
    
    public enum Kzt {
      /// Kazakhstani Tenge
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "KZT.Name")
      /// Kazakhstan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "KZT.Country")
    }
    
    public enum Mdl {
      /// Moldovan Leu
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "MDL.Name")
      /// Moldova
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "MDL.Country")
    }
    
    public enum Nok {
      /// Norwegian Krone
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "NOK.Name")
      /// Norway
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "NOK.Country")
    }
    
    public enum Nzd {
      /// New Zealand Dollar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "NZD.Name")
      /// New Zealand
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "NZD.Country")
    }
    
    public enum Pln {
      /// Polish Zloty
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "PLN.Name")
      /// Poland
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "PLN.Country")
    }
    
    public enum Qar {
      /// Qatari Riyal
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "QAR.Name")
      /// Qatar
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "QAR.Country")
    }
    
    public enum Ron {
      /// Romanian Leu
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "RON.Name")
      /// Romania
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "RON.Country")
    }
    
    public enum Rsd {
      /// Serbian Dinar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "RSD.Name")
      /// Serbia
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "RSD.Country")
    }
    
    public enum Rub {
      /// Russian Ruble
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "RUB.Name")
      /// Russia
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "RUB.Country")
    }
    
    public enum Sek {
      /// Swedish Krona
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "SEK.Name")
      /// Sweden
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "SEK.Country")
    }
    
    public enum Sgd {
      /// Singapore Dollar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "SGD.Name")
      /// Singapore
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "SGD.Country")
    }
    
    public enum Thb {
      /// Thai Baht
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "THB.Name")
      /// Thailand
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "THB.Country")
    }
    
    public enum Try {
      /// Turkish Lira
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "TRY.Name")
      /// Turkey
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "TRY.Country")
    }
    
    public enum Tjs {
      /// Tajikistani Somoni
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "TJS.Name")
      /// Tajikistan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "TJS.Country")
    }
    
    public enum Tmt {
      /// Turkmenistan Manat
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "TMT.Name")
      /// Turkmenistan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "TMT.Country")
    }
    
    public enum Uah {
      /// Ukrainian Hryvnia
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "UAH.Name")
      /// Ukraine
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "UAH.Country")
    }
    
    public enum Usd {
      /// US Dollar
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "USD.Name")
      /// United States
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "USD.Country")
    }
    
    public enum Uzs {
      /// Uzbek Som
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "UZS.Name")
      /// Uzbekistan
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "UZS.Country")
    }
    
    public enum Vnd {
      /// Vietnamese Dong
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "VND.Name")
      /// Vietnam
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "VND.Country")
    }
    
    public enum Zar {
      /// South African Rand
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "ZAR.Name")
      /// South Africa
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "ZAR.Country")
    }
    
    public enum Xdr {
      /// Special Drawing Rights (SDR)
      public static let name = SKAbstractionsStrings.tr("CurrencyModelLocalization", "XDR.Name")
      /// International Monetary Fund
      public static let country = SKAbstractionsStrings.tr("CurrencyModelLocalization", "XDR.Country")
    }
  }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension SKAbstractionsStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = SKAbstractionsResources.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all
