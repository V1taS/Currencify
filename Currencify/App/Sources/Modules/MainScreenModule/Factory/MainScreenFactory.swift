//
//  MainScreenFactory.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI
import SKAbstractions
import SKUIKit
import SKStyle

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {
  /// Пользователь нажал на валюту
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency, withRate rate: Double) async
  
  /// Пользователь вводит сумму
  func userDidEnterAmount(_ amount: Double, commaIsSet: Bool) async
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  func createCurrencyWidgetModels(
    forCurrency selectedCurrency: CurrencyRate.Currency,
    amountEntered: Double,
    isUserInputActive: Bool,
    availableRates: [CurrencyRate.Currency],
    rateCalculationMode: RateCalculationMode,
    decimalPlaces: CurrencyDecimalPlaces,
    commaIsSet: Bool,
    rateCorrectionPercentage: Double
  ) -> [WidgetCryptoView.Model]
}

/// Фабрика
final class MainScreenFactory {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Private properties
  
  private let textFormatterService: ITextFormatterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - textFormatterService: Текстовый форматер
  init(textFormatterService: ITextFormatterService) {
    self.textFormatterService = textFormatterService
  }
}

// MARK: - MainScreenFactoryInput

extension MainScreenFactory: MainScreenFactoryInput {
  func createCurrencyWidgetModels(
    forCurrency selectedCurrency: CurrencyRate.Currency,
    amountEntered: Double,
    isUserInputActive: Bool,
    availableRates: [CurrencyRate.Currency],
    rateCalculationMode: RateCalculationMode,
    decimalPlaces: CurrencyDecimalPlaces,
    commaIsSet: Bool,
    rateCorrectionPercentage: Double
  ) -> [WidgetCryptoView.Model] {
    var models: [WidgetCryptoView.Model] = []
    let allCurrencyRates: [CurrencyRate] = CurrencyRate.calculateCurrencyRates(
      from: selectedCurrency,
      amount: amountEntered,
      calculationMode: rateCalculationMode
    )
    let filteredCurrencyRates = allCurrencyRates.filter { currencyRate in
      availableRates.contains { selectedCurrency in
        currencyRate.currency == selectedCurrency
      }
    }

    for currencyRate in filteredCurrencyRates {
      models.append(
        createWidgetModel(
          selectedCurrency: selectedCurrency,
          currencyRate: currencyRate,
          currencyDecimalPlaces: decimalPlaces,
          isKeyboardShown: isUserInputActive,
          commaIsSet: commaIsSet,
          rateCorrectionPercentage: rateCorrectionPercentage
        )
      )
    }
    return models
  }
}

// MARK: - Private

private extension MainScreenFactory {
  func createWidgetModel(
    selectedCurrency: CurrencyRate.Currency,
    currencyRate: CurrencyRate,
    currencyDecimalPlaces: CurrencyDecimalPlaces,
    isKeyboardShown: Bool,
    commaIsSet: Bool,
    rateCorrectionPercentage: Double
  ) -> WidgetCryptoView.Model {
    var additionCenterContent: AnyView?
    var currencyRateRate = currencyRate.rate

    if rateCorrectionPercentage != .zero, currencyRate.currency != selectedCurrency {
      let correctedCurrencyRates = applyRateCorrection(
        to: currencyRate,
        correctionPercentage: rateCorrectionPercentage
      )
      currencyRateRate = correctedCurrencyRates.rate
    }
    
    let currencyValue = textFormatterService.formatDouble(
      currencyRateRate,
      decimalPlaces: currencyDecimalPlaces.rawValue
    )
    let currencyValueReplaceDotsWithCommas = textFormatterService.replaceDotsWithCommas(in: currencyValue)
    var currencyValueRemoveExtraZeros = textFormatterService.removeExtraZeros(
      from: currencyValueReplaceDotsWithCommas
    )
    
    if commaIsSet, currencyRate.currency == selectedCurrency {
      currencyValueRemoveExtraZeros += ","
    }
    
    if isKeyboardShown, currencyRate.currency == selectedCurrency {
      additionCenterContent = AnyView(
        KeyboardView(
          value: currencyValueRemoveExtraZeros,
          isEnabled: true
        ) {
          [weak self] newValue in
          guard let self else { return }
          let clearedTextFromSpaces = textFormatterService.removeAllSpaces(from: newValue)
          let textReplaceCommasWithDots = textFormatterService.replaceCommasWithDots(in: clearedTextFromSpaces)
          let textToDouble = Double(textReplaceCommasWithDots) ?? .zero
          let lastCharacterIsComma = newValue.last == ","
          
          let countCharactersAfterComma = textFormatterService.countCharactersAfterComma(in: newValue)
          if let countCharactersAfterComma, countCharactersAfterComma > currencyDecimalPlaces.rawValue {
            triggerHapticFeedback(.error)
          }
          
          Task { [weak self] in
            guard let self else { return }
            await output?.userDidEnterAmount(
              textToDouble,
              commaIsSet: lastCharacterIsComma
            )
          }
        }
          .padding(.top, .s4)
          .padding(.bottom, .s1)
      )
    }
    
    return WidgetCryptoView.Model(
      additionalID: currencyRate.currency.rawValue,
      leftSide: .init(
        itemModel: .custom(
          item: AnyView(
            Text(currencyRate.emojiFlag() ?? "")
              .font(.system(size: 40, weight: .bold))
              .lineLimit(1)
          ),
          size: .large
        ),
        titleModel: .init(
          text: currencyRate.currency.details.name,
          lineLimit: 1,
          textStyle: .standart
        ),
        descriptionModel: .init(
          text: currencyRate.currency.details.code.alpha,
          lineLimit: 1,
          textStyle: .netural
        )
      ),
      rightSide: .init(
        itemModel: .custom(
          item: AnyView(
            Text(currencyValueRemoveExtraZeros)
              .font(.fancy.constant.h2)
              .foregroundStyle(
                currencyRate.rate == .zero ? SKStyleAsset.constantSlate.swiftUIColor : SKStyleAsset.ghost.swiftUIColor
              )
              .lineLimit(1)
              .minimumScaleFactor(0.7)
          ),
          size: .custom(width: nil, height: nil)
        )
      ),
      additionCenterContent: additionCenterContent,
      backgroundColor: nil,
      action: { [weak self] in
        
        Task { [weak self] in
          guard let self else { return }
          await output?.userDidSelectCurrency(currencyRate.currency, withRate: currencyRate.rate)
        }
      }
    )
  }
  
  func triggerHapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }
  
  func applyRateCorrection(to currencyRate: CurrencyRate, correctionPercentage: Double) -> CurrencyRate {
    let correctedRate = currencyRate.rate * (1 + correctionPercentage / 100)
    return CurrencyRate(
      currency: currencyRate.currency,
      rate: correctedRate,
      lastUpdated: currencyRate.lastUpdated
    )
  }
}

// MARK: - Constants

private enum Constants {}
