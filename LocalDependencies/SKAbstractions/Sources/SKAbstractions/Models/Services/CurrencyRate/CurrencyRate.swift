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
  
  /// URL изображения
  public let imageURL: String?
  
  /// Инициализирует структуру `CurrencyRate` с указанной валютой, курсом и датой обновления.
  /// - Parameters:
  ///  - currency: Валюта, представленная в виде значения перечисления `Currency`.
  ///  - rate: Текущий курс валюты.
  ///  - lastUpdated: Дата последнего обновления курса.
  ///  - imageURL: URL изображения
  public init(
    currency: CurrencyRate.Currency,
    rate: Double,
    lastUpdated: Date,
    imageURL: String? = nil
  ) {
    self.currency = currency
    self.rate = rate
    self.lastUpdated = lastUpdated
    self.imageURL = imageURL
  }
}

// MARK: - CurrencyType

extension CurrencyRate {
  public enum CurrencyType {
    /// Валюта
    case currency
    
    /// Криптовалюта
    case crypto
    
    /// Акции
    case stock
  }
}

// MARK: - Currency

extension CurrencyRate {
  public enum Currency: String {
    // MARK: - Currency
    
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
    
    // MARK: - Crypto
    
    case bitcoin = "BTC"
    case ethereum = "ETH"
    case tether = "USDT"
    case bnb = "BNB"
    case solana = "SOL"
    case usdc = "USDC"
    case xrp = "XRP"
    case lidoStakedEther = "STETH"
    case dogecoin = "DOGE"
    case toncoin = "TON"
    case tron = "TRX"
    case cardano = "ADA"
    case avalanche = "AVAX"
    case wrappedStakedEther = "WSTETH"
    case wrappedBitcoin = "WBTC"
    case shibaInu = "SHIB"
    case weth = "WETH"
    case chainlink = "LINK"
    case bitcoinCash = "BCH"
    case polkadot = "DOT"
    case dai = "DAI"
    case leoToken = "LEO"
    case litecoin = "LTC"
    case uniswap = "UNI"
    case nearProtocol = "NEAR"
    case wrappedEETH = "WEETH"
    case kaspa = "KAS"
    case sui = "SUI"
    case artificialSuperintelligenceAlliance = "FET"
    case aptos = "APT"
    case internetComputer = "ICP"
    case pepe = "PEPE"
    case bittensor = "TAO"
    case monero = "XMR"
    case firstDigitalUSD = "FDUSD"
    case polExMATIC = "POL"
    case stellar = "XLM"
    case ethereumClassic = "ETC"
    case immutable = "IMX"
    case ethenaUSDe = "USDE"
    case stacks = "STX"
    case okb = "OKB"
    case aave = "AAVE"
    case cronos = "CRO"
    case filecoin = "FIL"
    case render = "RNDR"
    case arbitrum = "ARB"
    case injective = "INJ"
    case mantle = "MNT"
    case optimism = "OP"
    case hedera = "HBAR"
    case vechain = "VET"
    case cosmosHub = "ATOM"
    case fantom = "FTM"
    case dogwifhat = "WIF"
    case whitebitCoin = "WBT"
    case theGraph = "GRT"
    case thorChain = "RUNE"
    case rocketPoolETH = "RETH"
    case thetaNetwork = "THETA"
    case maker = "MKR"
    case bitgetToken = "BGB"
    case mantleStakedEther = "METH"
    case solvProtocolSolvBTC = "SOLVBTC"
    case arweave = "AR"
    case sei = "SEI"
    case floki = "FLOKI"
    case helium = "HNT"
    case bonk = "BONK"
    case polygon = "MATIC"
    case celestia = "TIA"
    case pythNetwork = "PYTH"
    case jupiter = "JUP"
    case algorand = "ALGO"
    case gate = "GT"
    case quant = "QNT"
    case lidoDAO = "LDO"
    case jasmyCoin = "JASMY"
    case ondo = "ONDO"
    case mantra = "OM"
    case renzoRestakedETH = "EZETH"
    case bitcoinSV = "BSV"
    case core = "CORE"
    case kuCoin = "KCS"
    case bitTorrent = "BTT"
    case flow = "FLOW"
    case beam = "BEAM"
    case popcat = "POPCAT"
    case gala = "GALA"
    case klaytn = "KLAY"
    case brett = "BRETT"
    case eos = "EOS"
    case multiversX = "EGLD"
    case tokenizeXchange = "TKX"
    case notcoin = "NOT"
    case fasttoken = "FTN"
    case axieInfinity = "AXS"
    
    /// Возвращает информацию о валюте: её локализованное название, страну и коды (буквенный и цифровой).
    public var details: (
      name: String,
      country: String,
      code: (alpha: String, numeric: String),
      source: CurrencyRate.CurrencyType
    ) {
      switch self {
      case .RUB:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Rub.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Rub.country,
          (
            alpha: "RUB",
            numeric: "643"
          ),
          source: .currency
        )
      case .CAD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Cad.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Cad.country,
          (
            alpha: "CAD",
            numeric: "124"
          ),
          source: .currency
        )
      case .EUR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Eur.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Eur.country,
          (
            alpha: "EUR",
            numeric: "978"
          ),
          source: .currency
        )
      case .BRL:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Brl.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Brl.country,
          (
            alpha: "BRL",
            numeric: "986"
          ),
          source: .currency
        )
      case .VND:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Vnd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Vnd.country,
          (
            alpha: "VND",
            numeric: "704"
          ),
          source: .currency
        )
      case .TMT:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Tmt.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Tmt.country,
          (
            alpha: "TMT",
            numeric: "934"
          ),
          source: .currency
        )
      case .HUF:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Huf.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Huf.country,
          (
            alpha: "HUF",
            numeric: "348"
          ),
          source: .currency
        )
      case .AZN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Azn.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Azn.country,
          (
            alpha: "AZN",
            numeric: "944"
          ),
          source: .currency
        )
      case .BYN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Byn.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Byn.country,
          (
            alpha: "BYN",
            numeric: "933"
          ),
          source: .currency
        )
      case .USD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Usd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Usd.country,
          (
            alpha: "USD",
            numeric: "840"
          ),
          source: .currency
        )
      case .ZAR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Zar.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Zar.country,
          (
            alpha: "ZAR",
            numeric: "710"
          ),
          source: .currency
        )
      case .CHF:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Chf.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Chf.country,
          (
            alpha: "CHF",
            numeric: "756"
          ),
          source: .currency
        )
      case .CZK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Czk.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Czk.country,
          (
            alpha: "CZK",
            numeric: "203"
          ),
          source: .currency
        )
      case .NZD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Nzd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Nzd.country,
          (
            alpha: "NZD",
            numeric: "554"
          ),
          source: .currency
        )
      case .TRY:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Try.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Try.country,
          (
            alpha: "TRY",
            numeric: "949"
          ),
          source: .currency
        )
      case .JPY:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Jpy.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Jpy.country,
          (
            alpha: "JPY",
            numeric: "392"
          ),
          source: .currency
        )
      case .QAR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Qar.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Qar.country,
          (
            alpha: "QAR",
            numeric: "634"
          ),
          source: .currency
        )
      case .BGN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Bgn.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Bgn.country,
          (
            alpha: "BGN",
            numeric: "975"
          ),
          source: .currency
        )
      case .SGD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Sgd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Sgd.country,
          (
            alpha: "SGD",
            numeric: "702"
          ),
          source: .currency
        )
      case .RSD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Rsd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Rsd.country,
          (
            alpha: "RSD",
            numeric: "941"
          ),
          source: .currency
        )
      case .NOK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Nok.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Nok.country,
          (
            alpha: "NOK",
            numeric: "578"
          ),
          source: .currency
        )
      case .HKD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Hkd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Hkd.country,
          (
            alpha: "HKD",
            numeric: "344"
          ),
          source: .currency
        )
      case .THB:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Thb.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Thb.country,
          (
            alpha: "THB",
            numeric: "764"
          ),
          source: .currency
        )
      case .SEK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Sek.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Sek.country,
          (
            alpha: "SEK",
            numeric: "752"
          ),
          source: .currency
        )
      case .MDL:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Mdl.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Mdl.country,
          (
            alpha: "MDL",
            numeric: "498"
          ),
          source: .currency
        )
      case .DKK:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Dkk.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Dkk.country,
          (
            alpha: "DKK",
            numeric: "208"
          ),
          source: .currency
        )
      case .AED:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Aed.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Aed.country,
          (
            alpha: "AED",
            numeric: "784"
          ),
          source: .currency
        )
      case .EGP:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Egp.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Egp.country,
          (
            alpha: "EGP",
            numeric: "818"
          ),
          source: .currency
        )
      case .KRW:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Krw.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Krw.country,
          (
            alpha: "KRW",
            numeric: "410"
          ),
          source: .currency
        )
      case .PLN:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Pln.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Pln.country,
          (
            alpha: "PLN",
            numeric: "985"
          ),
          source: .currency
        )
      case .IDR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Idr.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Idr.country,
          (
            alpha: "IDR",
            numeric: "360"
          ),
          source: .currency
        )
      case .CNY:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Cny.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Cny.country,
          (
            alpha: "CNY",
            numeric: "156"
          ),
          source: .currency
        )
      case .GBP:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Gbp.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Gbp.country,
          (
            alpha: "GBP",
            numeric: "826"
          ),
          source: .currency
        )
      case .GEL:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Gel.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Gel.country,
          (
            alpha: "GEL",
            numeric: "981"
          ),
          source: .currency
        )
      case .UAH:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Uah.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Uah.country,
          (
            alpha: "UAH",
            numeric: "980"
          ),
          source: .currency
        )
      case .KGS:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Kgs.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Kgs.country,
          (
            alpha: "KGS",
            numeric: "417"
          ),
          source: .currency
        )
      case .XDR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Xdr.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Xdr.country,
          (
            alpha: "XDR",
            numeric: "960"
          ),
          source: .currency
        )
      case .TJS:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Tjs.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Tjs.country,
          (
            alpha: "TJS",
            numeric: "972"
          ),
          source: .currency
        )
      case .AMD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Amd.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Amd.country,
          (
            alpha: "AMD",
            numeric: "051"
          ),
          source: .currency
        )
      case .AUD:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Aud.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Aud.country,
          (
            alpha: "AUD",
            numeric: "036"
          ),
          source: .currency
        )
      case .KZT:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Kzt.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Kzt.country,
          (
            alpha: "KZT",
            numeric: "398"
          ),
          source: .currency
        )
      case .RON:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Ron.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Ron.country,
          (
            alpha: "RON",
            numeric: "946"
          ),
          source: .currency
        )
      case .UZS:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Uzs.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Uzs.country,
          (
            alpha: "UZS",
            numeric: "860"
          ),
          source: .currency
        )
      case .INR:
        return (
          SKAbstractionsStrings.CurrencyModelLocalization.Inr.name,
          SKAbstractionsStrings.CurrencyModelLocalization.Inr.country,
          (
            alpha: "INR",
            numeric: "356"
          ),
          source: .currency
        )
        
        // MARK: - Crypto Cases
        
      case .bitcoin:
        return (
          name: "Bitcoin",
          country: "Decentralized",
          code: (alpha: "BTC", numeric: "N/A"),
          source: .crypto
        )
      case .ethereum:
        return (
          name: "Ethereum",
          country: "Decentralized",
          code: (alpha: "ETH", numeric: "N/A"),
          source: .crypto
        )
      case .tether:
        return (
          name: "Tether",
          country: "Decentralized",
          code: (alpha: "USDT", numeric: "N/A"),
          source: .crypto
        )
      case .bnb:
        return (
          name: "BNB",
          country: "Decentralized",
          code: (alpha: "BNB", numeric: "N/A"),
          source: .crypto
        )
      case .solana:
        return (
          name: "Solana",
          country: "Decentralized",
          code: (alpha: "SOL", numeric: "N/A"),
          source: .crypto
        )
      case .usdc:
        return (
          name: "USD Coin",
          country: "Decentralized",
          code: (alpha: "USDC", numeric: "N/A"),
          source: .crypto
        )
      case .xrp:
        return (
          name: "XRP",
          country: "Decentralized",
          code: (alpha: "XRP", numeric: "N/A"),
          source: .crypto
        )
      case .lidoStakedEther:
        return (
          name: "Lido Staked Ether",
          country: "Decentralized",
          code: (alpha: "STETH", numeric: "N/A"),
          source: .crypto
        )
      case .dogecoin:
        return (
          name: "Dogecoin",
          country: "Decentralized",
          code: (alpha: "DOGE", numeric: "N/A"),
          source: .crypto
        )
      case .toncoin:
        return (
          name: "Toncoin",
          country: "Decentralized",
          code: (alpha: "TON", numeric: "N/A"),
          source: .crypto
        )
      case .tron:
        return (
          name: "TRON",
          country: "Decentralized",
          code: (alpha: "TRX", numeric: "N/A"),
          source: .crypto
        )
      case .cardano:
        return (
          name: "Cardano",
          country: "Decentralized",
          code: (alpha: "ADA", numeric: "N/A"),
          source: .crypto
        )
      case .avalanche:
        return (
          name: "Avalanche",
          country: "Decentralized",
          code: (alpha: "AVAX", numeric: "N/A"),
          source: .crypto
        )
      case .wrappedStakedEther:
        return (
          name: "Wrapped Staked Ether",
          country: "Decentralized",
          code: (alpha: "WSTETH", numeric: "N/A"),
          source: .crypto
        )
      case .wrappedBitcoin:
        return (
          name: "Wrapped Bitcoin",
          country: "Decentralized",
          code: (alpha: "WBTC", numeric: "N/A"),
          source: .crypto
        )
      case .shibaInu:
        return (
          name: "Shiba Inu",
          country: "Decentralized",
          code: (alpha: "SHIB", numeric: "N/A"),
          source: .crypto
        )
      case .weth:
        return (
          name: "Wrapped Ether",
          country: "Decentralized",
          code: (alpha: "WETH", numeric: "N/A"),
          source: .crypto
        )
      case .chainlink:
        return (
          name: "Chainlink",
          country: "Decentralized",
          code: (alpha: "LINK", numeric: "N/A"),
          source: .crypto
        )
      case .bitcoinCash:
        return (
          name: "Bitcoin Cash",
          country: "Decentralized",
          code: (alpha: "BCH", numeric: "N/A"),
          source: .crypto
        )
      case .polkadot:
        return (
          name: "Polkadot",
          country: "Decentralized",
          code: (alpha: "DOT", numeric: "N/A"),
          source: .crypto
        )
      case .dai:
        return (
          name: "Dai",
          country: "Decentralized",
          code: (alpha: "DAI", numeric: "N/A"),
          source: .crypto
        )
      case .leoToken:
        return (
          name: "LEO Token",
          country: "Decentralized",
          code: (alpha: "LEO", numeric: "N/A"),
          source: .crypto
        )
      case .litecoin:
        return (
          name: "Litecoin",
          country: "Decentralized",
          code: (alpha: "LTC", numeric: "N/A"),
          source: .crypto
        )
      case .uniswap:
        return (
          name: "Uniswap",
          country: "Decentralized",
          code: (alpha: "UNI", numeric: "N/A"),
          source: .crypto
        )
      case .nearProtocol:
        return (
          name: "NEAR Protocol",
          country: "Decentralized",
          code: (alpha: "NEAR", numeric: "N/A"),
          source: .crypto
        )
      case .wrappedEETH:
        return (
          name: "Wrapped EETH",
          country: "Decentralized",
          code: (alpha: "WEETH", numeric: "N/A"),
          source: .crypto
        )
      case .kaspa:
        return (
          name: "Kaspa",
          country: "Decentralized",
          code: (alpha: "KAS", numeric: "N/A"),
          source: .crypto
        )
      case .sui:
        return (
          name: "Sui",
          country: "Decentralized",
          code: (alpha: "SUI", numeric: "N/A"),
          source: .crypto
        )
      case .artificialSuperintelligenceAlliance:
        return (
          name: "Artificial Superintelligence Alliance",
          country: "Decentralized",
          code: (alpha: "FET", numeric: "N/A"),
          source: .crypto
        )
      case .aptos:
        return (
          name: "Aptos",
          country: "Decentralized",
          code: (alpha: "APT", numeric: "N/A"),
          source: .crypto
        )
      case .internetComputer:
        return (
          name: "Internet Computer",
          country: "Decentralized",
          code: (alpha: "ICP", numeric: "N/A"),
          source: .crypto
        )
      case .pepe:
        return (
          name: "Pepe",
          country: "Decentralized",
          code: (alpha: "PEPE", numeric: "N/A"),
          source: .crypto
        )
      case .bittensor:
        return (
          name: "Bittensor",
          country: "Decentralized",
          code: (alpha: "TAO", numeric: "N/A"),
          source: .crypto
        )
      case .monero:
        return (
          name: "Monero",
          country: "Decentralized",
          code: (alpha: "XMR", numeric: "N/A"),
          source: .crypto
        )
      case .firstDigitalUSD:
        return (
          name: "First Digital USD",
          country: "Decentralized",
          code: (alpha: "FDUSD", numeric: "N/A"),
          source: .crypto
        )
      case .polExMATIC:
        return (
          name: "POL (ex-MATIC)",
          country: "Decentralized",
          code: (alpha: "POL", numeric: "N/A"),
          source: .crypto
        )
      case .stellar:
        return (
          name: "Stellar",
          country: "Decentralized",
          code: (alpha: "XLM", numeric: "N/A"),
          source: .crypto
        )
      case .ethereumClassic:
        return (
          name: "Ethereum Classic",
          country: "Decentralized",
          code: (alpha: "ETC", numeric: "N/A"),
          source: .crypto
        )
      case .immutable:
        return (
          name: "Immutable",
          country: "Decentralized",
          code: (alpha: "IMX", numeric: "N/A"),
          source: .crypto
        )
      case .ethenaUSDe:
        return (
          name: "Ethena USDe",
          country: "Decentralized",
          code: (alpha: "USDE", numeric: "N/A"),
          source: .crypto
        )
      case .stacks:
        return (
          name: "Stacks",
          country: "Decentralized",
          code: (alpha: "STX", numeric: "N/A"),
          source: .crypto
        )
      case .okb:
        return (
          name: "OKB",
          country: "Decentralized",
          code: (alpha: "OKB", numeric: "N/A"),
          source: .crypto
        )
      case .aave:
        return (
          name: "Aave",
          country: "Decentralized",
          code: (alpha: "AAVE", numeric: "N/A"),
          source: .crypto
        )
      case .cronos:
        return (
          name: "Cronos",
          country: "Decentralized",
          code: (alpha: "CRO", numeric: "N/A"),
          source: .crypto
        )
      case .filecoin:
        return (
          name: "Filecoin",
          country: "Decentralized",
          code: (alpha: "FIL", numeric: "N/A"),
          source: .crypto
        )
      case .render:
        return (
          name: "Render",
          country: "Decentralized",
          code: (alpha: "RNDR", numeric: "N/A"),
          source: .crypto
        )
      case .arbitrum:
        return (
          name: "Arbitrum",
          country: "Decentralized",
          code: (alpha: "ARB", numeric: "N/A"),
          source: .crypto
        )
      case .injective:
        return (
          name: "Injective",
          country: "Decentralized",
          code: (alpha: "INJ", numeric: "N/A"),
          source: .crypto
        )
      case .mantle:
        return (
          name: "Mantle",
          country: "Decentralized",
          code: (alpha: "MNT", numeric: "N/A"),
          source: .crypto
        )
      case .optimism:
        return (
          name: "Optimism",
          country: "Decentralized",
          code: (alpha: "OP", numeric: "N/A"),
          source: .crypto
        )
      case .hedera:
        return (
          name: "Hedera",
          country: "Decentralized",
          code: (alpha: "HBAR", numeric: "N/A"),
          source: .crypto
        )
      case .vechain:
        return (
          name: "VeChain",
          country: "Decentralized",
          code: (alpha: "VET", numeric: "N/A"),
          source: .crypto
        )
      case .cosmosHub:
        return (
          name: "Cosmos Hub",
          country: "Decentralized",
          code: (alpha: "ATOM", numeric: "N/A"),
          source: .crypto
        )
      case .fantom:
        return (
          name: "Fantom",
          country: "Decentralized",
          code: (alpha: "FTM", numeric: "N/A"),
          source: .crypto
        )
      case .dogwifhat:
        return (
          name: "Dogwifhat",
          country: "Decentralized",
          code: (alpha: "WIF", numeric: "N/A"),
          source: .crypto
        )
      case .whitebitCoin:
        return (
          name: "WhiteBIT Coin",
          country: "Decentralized",
          code: (alpha: "WBT", numeric: "N/A"),
          source: .crypto
        )
      case .theGraph:
        return (
          name: "The Graph",
          country: "Decentralized",
          code: (alpha: "GRT", numeric: "N/A"),
          source: .crypto
        )
      case .thorChain:
        return (
          name: "THORChain",
          country: "Decentralized",
          code: (alpha: "RUNE", numeric: "N/A"),
          source: .crypto
        )
      case .rocketPoolETH:
        return (
          name: "Rocket Pool ETH",
          country: "Decentralized",
          code: (alpha: "RETH", numeric: "N/A"),
          source: .crypto
        )
      case .thetaNetwork:
        return (
          name: "Theta Network",
          country: "Decentralized",
          code: (alpha: "THETA", numeric: "N/A"),
          source: .crypto
        )
      case .maker:
        return (
          name: "Maker",
          country: "Decentralized",
          code: (alpha: "MKR", numeric: "N/A"),
          source: .crypto
        )
      case .bitgetToken:
        return (
          name: "Bitget Token",
          country: "Decentralized",
          code: (alpha: "BGB", numeric: "N/A"),
          source: .crypto
        )
      case .mantleStakedEther:
        return (
          name: "Mantle Staked Ether",
          country: "Decentralized",
          code: (alpha: "METH", numeric: "N/A"),
          source: .crypto
        )
      case .solvProtocolSolvBTC:
        return (
          name: "Solv Protocol SolvBTC",
          country: "Decentralized",
          code: (alpha: "SOLVBTC", numeric: "N/A"),
          source: .crypto
        )
      case .arweave:
        return (
          name: "Arweave",
          country: "Decentralized",
          code: (alpha: "AR", numeric: "N/A"),
          source: .crypto
        )
      case .sei:
        return (
          name: "Sei",
          country: "Decentralized",
          code: (alpha: "SEI", numeric: "N/A"),
          source: .crypto
        )
      case .floki:
        return (
          name: "FLOKI",
          country: "Decentralized",
          code: (alpha: "FLOKI", numeric: "N/A"),
          source: .crypto
        )
      case .helium:
        return (
          name: "Helium",
          country: "Decentralized",
          code: (alpha: "HNT", numeric: "N/A"),
          source: .crypto
        )
      case .bonk:
        return (
          name: "Bonk",
          country: "Decentralized",
          code: (alpha: "BONK", numeric: "N/A"),
          source: .crypto
        )
      case .polygon:
        return (
          name: "Polygon",
          country: "Decentralized",
          code: (alpha: "MATIC", numeric: "N/A"),
          source: .crypto
        )
      case .celestia:
        return (
          name: "Celestia",
          country: "Decentralized",
          code: (alpha: "TIA", numeric: "N/A"),
          source: .crypto
        )
      case .pythNetwork:
        return (
          name: "Pyth Network",
          country: "Decentralized",
          code: (alpha: "PYTH", numeric: "N/A"),
          source: .crypto
        )
      case .jupiter:
        return (
          name: "Jupiter",
          country: "Decentralized",
          code: (alpha: "JUP", numeric: "N/A"),
          source: .crypto
        )
      case .algorand:
        return (
          name: "Algorand",
          country: "Decentralized",
          code: (alpha: "ALGO", numeric: "N/A"),
          source: .crypto
        )
      case .gate:
        return (
          name: "Gate",
          country: "Decentralized",
          code: (alpha: "GT", numeric: "N/A"),
          source: .crypto
        )
      case .quant:
        return (
          name: "Quant",
          country: "Decentralized",
          code: (alpha: "QNT", numeric: "N/A"),
          source: .crypto
        )
      case .lidoDAO:
        return (
          name: "Lido DAO",
          country: "Decentralized",
          code: (alpha: "LDO", numeric: "N/A"),
          source: .crypto
        )
      case .jasmyCoin:
        return (
          name: "JasmyCoin",
          country: "Decentralized",
          code: (alpha: "JASMY", numeric: "N/A"),
          source: .crypto
        )
      case .ondo:
        return (
          name: "Ondo",
          country: "Decentralized",
          code: (alpha: "ONDO", numeric: "N/A"),
          source: .crypto
        )
      case .mantra:
        return (
          name: "MANTRA",
          country: "Decentralized",
          code: (alpha: "OM", numeric: "N/A"),
          source: .crypto
        )
      case .renzoRestakedETH:
        return (
          name: "Renzo Restaked ETH",
          country: "Decentralized",
          code: (alpha: "EZETH", numeric: "N/A"),
          source: .crypto
        )
      case .bitcoinSV:
        return (
          name: "Bitcoin SV",
          country: "Decentralized",
          code: (alpha: "BSV", numeric: "N/A"),
          source: .crypto
        )
      case .core:
        return (
          name: "Core",
          country: "Decentralized",
          code: (alpha: "CORE", numeric: "N/A"),
          source: .crypto
        )
      case .kuCoin:
        return (
          name: "KuCoin",
          country: "Decentralized",
          code: (alpha: "KCS", numeric: "N/A"),
          source: .crypto
        )
      case .bitTorrent:
        return (
          name: "BitTorrent",
          country: "Decentralized",
          code: (alpha: "BTT", numeric: "N/A"),
          source: .crypto
        )
      case .flow:
        return (
          name: "Flow",
          country: "Decentralized",
          code: (alpha: "FLOW", numeric: "N/A"),
          source: .crypto
        )
      case .beam:
        return (
          name: "Beam",
          country: "Decentralized",
          code: (alpha: "BEAM", numeric: "N/A"),
          source: .crypto
        )
      case .popcat:
        return (
          name: "Popcat",
          country: "Decentralized",
          code: (alpha: "POPCAT", numeric: "N/A"),
          source: .crypto
        )
      case .gala:
        return (
          name: "GALA",
          country: "Decentralized",
          code: (alpha: "GALA", numeric: "N/A"),
          source: .crypto
        )
      case .klaytn:
        return (
          name: "Klaytn",
          country: "Decentralized",
          code: (alpha: "KLAY", numeric: "N/A"),
          source: .crypto
        )
      case .brett:
        return (
          name: "Brett",
          country: "Decentralized",
          code: (alpha: "BRETT", numeric: "N/A"),
          source: .crypto
        )
      case .eos:
        return (
          name: "EOS",
          country: "Decentralized",
          code: (alpha: "EOS", numeric: "N/A"),
          source: .crypto
        )
      case .multiversX:
        return (
          name: "MultiversX",
          country: "Decentralized",
          code: (alpha: "EGLD", numeric: "N/A"),
          source: .crypto
        )
      case .tokenizeXchange:
        return (
          name: "Tokenize Xchange",
          country: "Decentralized",
          code: (alpha: "TKX", numeric: "N/A"),
          source: .crypto
        )
      case .notcoin:
        return (
          name: "Notcoin",
          country: "Decentralized",
          code: (alpha: "NOT", numeric: "N/A"),
          source: .crypto
        )
      case .fasttoken:
        return (
          name: "Fasttoken",
          country: "Decentralized",
          code: (alpha: "FTN", numeric: "N/A"),
          source: .crypto
        )
      case .axieInfinity:
        return (
          name: "Axie Infinity",
          country: "Decentralized",
          code: (alpha: "AXS", numeric: "N/A"),
          source: .crypto
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
      lastUpdated: outputCurrency.lastUpdated,
      imageURL: outputCurrency.imageURL
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
extension CurrencyRate.CurrencyType: IdentifiableAndCodable {}
