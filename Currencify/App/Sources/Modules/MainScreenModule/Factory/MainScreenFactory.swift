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
import SKFoundation

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {
  /// Пользователь нажал на валюту
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency) async
  
  /// Пользователь вводит сумму
  func userDidEnterAmount(_ newValue: String) async
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  func createCurrencyWidgetModels(
    decimalPlaces: CurrencyDecimalPlaces,
    currencyRateIdentifiables: [CurrencyRateIdentifiable]
  ) -> [WidgetCryptoView.Model]
}

/// Фабрика
final class MainScreenFactory {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
}

// MARK: - MainScreenFactoryInput

extension MainScreenFactory: MainScreenFactoryInput {
  func createCurrencyWidgetModels(
    decimalPlaces: CurrencyDecimalPlaces,
    currencyRateIdentifiables: [CurrencyRateIdentifiable]
  ) -> [WidgetCryptoView.Model] {
    var models: [WidgetCryptoView.Model] = []
    
    for currencyRateIdentifiable in currencyRateIdentifiables {
      models.append(
        createWidgetModel(
          currencyDecimalPlaces: decimalPlaces,
          currencyRateIdentifiable: currencyRateIdentifiable
        )
      )
    }
    return models
  }
}

// MARK: - Private

private extension MainScreenFactory {
  func createWidgetModel(
    currencyDecimalPlaces: CurrencyDecimalPlaces,
    currencyRateIdentifiable: CurrencyRateIdentifiable
  ) -> WidgetCryptoView.Model {
    var leftSideImage = AnyView(EmptyView())
    
    if currencyRateIdentifiable.currency.details.source == .currency {
      leftSideImage = AnyView(
        Text(currencyRateIdentifiable.currency.emojiFlag() ?? "")
          .font(.system(size: 50, weight: .bold))
          .lineLimit(1)
      )
    } else {
      leftSideImage = AnyView(
        AsyncNetworkImageView(
          .init(
            imageUrl: currencyRateIdentifiable.imageURL,
            size: .init(width: 40, height: 40),
            cornerRadiusType: .squircle
          )
        )
        .frame(width: 50, height: 50)
        .padding(.vertical, .s1)
      )
    }
    
    return WidgetCryptoView.Model(
      additionalID: currencyRateIdentifiable.currency.rawValue,
      leftSide: .init(
        itemModel: .custom(
          item: leftSideImage,
          size: .custom(width: .infinity, height: nil)
        ),
        titleModel: .init(
          text: currencyRateIdentifiable.currency.details.name.formatString(minTextLength: 14),
          textFont: .fancy.text.regularMedium,
          lineLimit: 1,
          textStyle: .standart
        ),
        descriptionModel: .init(
          text: currencyRateIdentifiable.currency.details.code.alpha,
          textFont: .fancy.text.small,
          lineLimit: 1,
          textStyle: .netural
        )
      ),
      rightSideLargeTextModel: .init(
        text: currencyRateIdentifiable.rateText,
        textStyle: currencyRateIdentifiable.rateDouble == .zero ? .netural : .standart
      ),
      keyboardModel: .init(
        value: currencyRateIdentifiable.rateText,
        isKeyboardShown: false,
        onChange: { [weak self] newValue in
          Task { [weak self] in
            guard let self else { return }
            await output?.userDidEnterAmount(newValue)
          }
        }
      ),
      backgroundColor: nil,
      horizontalSpacing: .s2,
      leadingPadding: .s2,
      trailingPadding: .s3,
      verticalPadding: .zero,
      action: { [weak self] in
        Task { [weak self] in
          guard let self else { return }
          await output?.userDidSelectCurrency(currencyRateIdentifiable.currency)
        }
      }
    )
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
