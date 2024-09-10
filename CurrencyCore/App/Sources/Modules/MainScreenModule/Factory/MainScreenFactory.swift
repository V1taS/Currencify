//
//  MainScreenFactory.swift
//  CurrencyCore
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
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency, withRate rate: Double)
  
  /// Пользователь вводит сумму
  func userDidEnterAmount(_ amount: String)
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  /// Создает модели для виджета на основе выбранной валюты, текущего значения валюты, отображения клавиатуры, режима расчета и количества знаков после запятой.
  /// Метод принимает выбранную валюту, текущее значение валюты, статус отображения клавиатуры, список валют, режим расчета и количество знаков после запятой, после чего формирует модели для отображения в виджете.
  /// - Parameters:
  ///   - selectedCurrency: Текущая выбранная валюта, для которой производится расчет.
  ///   - currentCurrencyValue: Текущее значение валюты, которое используется для расчетов.
  ///   - isKeyboardShown: Флаг, указывающий на то, отображена ли клавиатура.
  ///   - selectedCurrencyRates: Список валют, для которых нужно создать модели.
  ///   - calculationMode: Режим расчета валютных курсов (прямой или обратный).
  ///   - currencyDecimalPlaces: Количество знаков после запятой для отображения валютных значений.
  /// - Returns: Массив моделей `WidgetCryptoView.Model` для отображения в виджете.
  func createCurrencyWidgetModels(
    forCurrency selectedCurrency: CurrencyRate.Currency,
    amountEntered: String,
    isUserInputActive: Bool,
    availableRates: [CurrencyRate.Currency],
    rateCalculationMode: RateCalculationMode,
    decimalPlaces: CurrencyDecimalPlaces
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
    forCurrency selectedCurrency: CurrencyRate.Currency,
    amountEntered: String,
    isUserInputActive: Bool,
    availableRates: [CurrencyRate.Currency],
    rateCalculationMode: RateCalculationMode,
    decimalPlaces: CurrencyDecimalPlaces
  ) -> [WidgetCryptoView.Model] {
    var models: [WidgetCryptoView.Model] = []
    let allCurrencyRates: [CurrencyRate] = CurrencyRate.calculateCurrencyRates(
      from: selectedCurrency,
      amount: Double(amountEntered) ?? .zero,
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
          currentCurrencyValue: amountEntered,
          isKeyboardShown: isUserInputActive
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
    currentCurrencyValue: String,
    isKeyboardShown: Bool
  ) -> WidgetCryptoView.Model {
    var additionCenterContent: AnyView?
    let value = (Double(currentCurrencyValue) ?? .zero) == .zero ? "0" : removeLeadingZeros(from: replaceCommasWithDots(in: currentCurrencyValue))
    
    if isKeyboardShown, currencyRate.currency == selectedCurrency {
      additionCenterContent = AnyView(
        KeyboardView(
          value: value,
          isEnabled: true
        ) { [weak self] newValue in
          guard let self else { return }
          output?.userDidEnterAmount(addZeroIfNeeded(in: replaceCommasWithDots(in: newValue)))
        }
          .padding(.top, .s4)
          .padding(.bottom, .s1)
      )
    }
    
    let title: AnyView = if currencyRate.currency == selectedCurrency, isKeyboardShown {
      AnyView(
        Text(truncateAfterDecimalSeparator(in: removeLeadingZeros(from: value), toPlaces: currencyDecimalPlaces.rawValue))
          .font(.fancy.constant.h2)
          .foregroundStyle(
            (Double(currentCurrencyValue) ?? .zero) == .zero ? SKStyleAsset.constantSlate.swiftUIColor : SKStyleAsset.ghost.swiftUIColor
          )
          .lineLimit(1)
          .minimumScaleFactor(0.7)
      )
    } else {
      AnyView(
        Text(formatAmount(currencyRate.rate, fractionDigits: currencyDecimalPlaces.rawValue))
          .font(.fancy.constant.h2)
          .foregroundStyle(
            (Double(currentCurrencyValue) ?? .zero) == .zero ? SKStyleAsset.constantSlate.swiftUIColor : SKStyleAsset.ghost.swiftUIColor
          )
          .lineLimit(1)
          .minimumScaleFactor(0.7)
      )
    }
    
    return WidgetCryptoView.Model(
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
          item: title,
          size: .custom(width: nil, height: nil)
        )
      ),
      additionCenterContent: additionCenterContent,
      backgroundColor: nil,
      action: { [weak self] in
        guard let self else { return }
        output?.userDidSelectCurrency(currencyRate.currency, withRate: currencyRate.rate)
      }
    )
  }
  
  func formatAmount(_ amount: Double, fractionDigits: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = fractionDigits
    numberFormatter.minimumFractionDigits = fractionDigits
    numberFormatter.groupingSeparator = " "  // Разделитель разрядов
    numberFormatter.decimalSeparator = ","   // Разделитель дробной части
    if let formattedAmount = numberFormatter.string(from: NSNumber(value: amount)) {
      return formattedAmount
    }
    return String(format: "%.\(fractionDigits)f", amount).replacingOccurrences(of: ".", with: ",")
  }
  
  func removeLeadingZeros(from string: String) -> String {
      // Удаляем ведущие нули
      var cleanedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
      
      // Удаляем ведущие нули, если они есть перед значащими цифрами
      cleanedString = cleanedString.replacingOccurrences(of: "^0+(?=[^0])", with: "", options: .regularExpression)
      
      // Проверяем наличие запятой или точки для обработки дробной части
      if let decimalSeparatorIndex = cleanedString.firstIndex(where: { $0 == "." || $0 == "," }) {
          let beforeSeparator = cleanedString[..<decimalSeparatorIndex]
          let afterSeparator = cleanedString[cleanedString.index(after: decimalSeparatorIndex)...]
          
          // Убираем только крайние нули справа после запятой или точки
          let trimmedAfterSeparator = afterSeparator.replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
          
          // Если вся дробная часть оказалась пустой, убираем и разделитель
          if trimmedAfterSeparator.isEmpty {
              cleanedString = String(beforeSeparator)
          } else {
              cleanedString = String(beforeSeparator) + String(cleanedString[decimalSeparatorIndex]) + trimmedAfterSeparator
          }
      }
      
      // Если строка оказалась пустой (например, была "000"), возвращаем "0"
      return cleanedString.isEmpty ? "0" : cleanedString
  }
  
  func replaceCommasWithDots(in string: String) -> String {
    return string.replacingOccurrences(of: ",", with: ".")
  }
  
  func truncateAfterDecimalSeparator(in string: String, toPlaces places: Int) -> String {
    // Определяем разделители (запятая или точка)
    let decimalSeparators: [Character] = [".", ","]
    
    // Ищем индекс первого разделителя
    if let separatorIndex = string.firstIndex(where: { decimalSeparators.contains($0) }) {
      // Разделяем строку на две части: до и после разделителя
      let beforeSeparator = string[..<separatorIndex]
      let afterSeparator = string[string.index(after: separatorIndex)...]
      
      // Ограничиваем количество символов после разделителя
      let truncatedAfterSeparator = afterSeparator.prefix(places)
      
      // Собираем строку обратно
      return String(beforeSeparator) + String(string[separatorIndex]) + truncatedAfterSeparator
    }
    
    // Если нет запятой или точки, возвращаем строку без изменений
    return string
  }
  
  func addZeroIfNeeded(in string: String) -> String {
    // Ищем индекс точки или запятой
    if let decimalSeparatorIndex = string.firstIndex(where: { $0 == "." || $0 == "," }) {
      let afterSeparator = string[string.index(after: decimalSeparatorIndex)...]
      
      // Если после разделителя ничего нет, добавляем "0"
      if afterSeparator.isEmpty {
        return string + "0"
      }
    }
    
    // Если ничего менять не нужно, возвращаем исходную строку
    return string
  }
}

// MARK: - Constants

private enum Constants {}
