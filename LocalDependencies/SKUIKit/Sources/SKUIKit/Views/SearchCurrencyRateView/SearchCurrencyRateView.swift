//
//  SearchCurrencyRateView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 15.09.2024.
//

import SwiftUI
import SKStyle
import SKUIKit
import SKAbstractions
import SKFoundation

public struct SearchCurrencyRateView: View {
  
  // MARK: - Private properties
  
  @State private var text: String = ""
  private let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
  
  @State private var isEnabled: Bool = true
  private let action: ((_ newValue: CurrencyRate) -> Void)?
  @State private var filteredCurrencyRates: [CurrencyRate] = []
  private var currencyRates: [CurrencyRate] = []
  private var availableCurrencyRate: [CurrencyRate.Currency] = []
  private let placeholder: String
  private var currencyTypes: [CurrencyRate.CurrencyType]
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - placeholder: Плейсхолдер
  ///   - currencyRates: Список курсов валют
  ///   - availableCurrencyRate: Уже выбранные валюты
  ///   - isEnabled: Свитчер включен
  ///   - currencyTypes: Типы валют
  ///   - action: Действие по нажатию
  public init(
    placeholder: String,
    currencyRates: [CurrencyRate],
    availableCurrencyRate: [CurrencyRate.Currency],
    isEnabled: Bool = true,
    currencyTypes: [CurrencyRate.CurrencyType],
    action: ((_ newValue: CurrencyRate) -> Void)?
  ) {
    self.placeholder = placeholder
    self.currencyRates = currencyRates
    self.availableCurrencyRate = availableCurrencyRate
    self.isEnabled = isEnabled
    self.currencyTypes = currencyTypes
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    ZStack(alignment: .topLeading) {
      VStack(alignment: .leading, spacing: .zero) {
        ChatFieldView(
          "\(placeholder)",
          message: $text,
          maxLength: 10,
          onChange: { _ in },
          header: nil,
          footer: {
            AnyView(EmptyView())
          }
        )
        .chatFieldStyle(.capsule)
        .padding(.all, .s4)
        
        // Отображаем до трех компонентов внутри
        if !text.isEmpty {
          ForEach(filteredCurrencyRates, id: \.self) { currencyRate in
            WidgetCryptoView(
              .init(
                leftSide: .init(
                  itemModel: .custom(
                    item: getleftImageView(currencyRate: currencyRate)
                  ),
                  titleModel: .init(
                    text: currencyRate.currency.details.name.formatString(minTextLength: 16),
                    lineLimit: 1,
                    textStyle: .standart
                  ),
                  descriptionModel: .init(
                    text: currencyRate.currency.details.code.alpha,
                    lineLimit: 1,
                    textStyle: .netural
                  )
                ),
                backgroundColor: nil,
                action: {
                  action?(currencyRate)
                }
              )
            )
            .clipShape(RoundedRectangle(cornerRadius: .s3))
            .padding(.horizontal, .s4)
            .padding(.bottom, .s4)
          }
          .transition(.opacity)
        }
        
        Spacer(minLength: .zero) // Позволяет VStack сжаться по содержимому
      }
      .background(SKStyleAsset.constantSearchCurrency.swiftUIColor)
      .cornerRadius(.s3)
      .fixedSize(horizontal: false, vertical: true)
      .animation(.default, value: text)
      .frame(width: UIScreen.main.bounds.width / 1.5)
      
      // Добавляем треугольник
      Triangle()
        .fill(SKStyleAsset.constantSearchCurrency.swiftUIColor)
        .rotationEffect(.degrees(180))
        .frame(width: 20, height: 20)
        .rotationEffect(Angle(degrees: 45))
        .offset(x: 10, y: -10)
        .animation(.default, value: text)
    }
    .onChange(of: text) { newValue in
      self.filteredCurrencyRates = filterTopThreeCurrencyRates(
        with: newValue,
        from: currencyRates
      )
    }
  }
}

// MARK: - Triangle Shape

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    // Начинаем с нижнего правого угла
    path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
    // Линия к верхнему левому углу (косая левая сторона)
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    // Линия к нижнему левому углу (прямая левая сторона)
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    // Замыкаем треугольник
    path.closeSubpath()
    return path
  }
}

// MARK: - Private

private extension SearchCurrencyRateView {
  func filterTopThreeCurrencyRates(
    with searchText: String,
    from currencyRates: [CurrencyRate]
  ) -> [CurrencyRate] {
    guard !searchText.isEmpty else {
      return []
    }
    
    let textLowercased = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Исключаем уже выбранные валюты и фильтруем по типу валюты
    let filteredCurrencyRates = currencyRates.filter { rate in
      !availableCurrencyRate.contains(where: { $0 == rate.currency }) &&
      currencyTypes.contains(rate.currency.details.source)
    }
    
    // Рассчитываем оценку для каждой оставшейся валюты
    let scoredRates = filteredCurrencyRates.map { rate -> (CurrencyRate, Int) in
      let currencyName = rate.currency.details.name.lowercased()
      let currencyCodeAlpha = rate.currency.details.code.alpha.lowercased()
      let currencyCodeNumeric = rate.currency.details.code.numeric.lowercased()
      let countryName = rate.currency.details.country.lowercased()
      
      var score = 0
      
      // Точные совпадения
      if currencyCodeAlpha == textLowercased {
        score += 100
      }
      if currencyCodeNumeric == textLowercased {
        score += 90
      }
      if currencyName == textLowercased {
        score += 80
      }
      if countryName == textLowercased {
        score += 70
      }
      
      // Частичные совпадения
      if currencyCodeAlpha.contains(textLowercased) {
        score += 50
      }
      if currencyCodeNumeric.contains(textLowercased) {
        score += 40
      }
      if currencyName.contains(textLowercased) {
        score += 30
      }
      if countryName.contains(textLowercased) {
        score += 20
      }
      
      return (rate, score)
    }
    
    // Фильтруем валюты с ненулевым баллом
    let nonZeroScoredRates = scoredRates.filter { $0.1 > 0 }
    
    // Сортируем валюты по баллам в порядке убывания
    let sortedRates = nonZeroScoredRates.sorted { $0.1 > $1.1 }
    
    // Берем первые три валюты
    let topThreeRates = sortedRates.prefix(3).map { $0.0 }
    
    return topThreeRates
  }
  
  func getleftImageView(currencyRate: CurrencyRate) -> AnyView {
    if currencyRate.currency.details.source == .currency {
      return AnyView(
        Text(currencyRate.currency.emojiFlag() ?? "")
          .font(.system(size: 40, weight: .bold))
          .lineLimit(1)
      )
    } else {
      return AnyView(
        AsyncNetworkImageView(
          .init(
            imageUrl: URL(string: currencyRate.imageURL ?? ""),
            size: .init(width: 30, height: 30),
            cornerRadiusType: .squircle
          )
        )
        .frame(width: 40, height: 40)
        .padding(.vertical, .s1)
      )
    }
  }
}

// MARK: - Constants

private enum Constants {}

// MARK: - Preview

struct SearchCurrencyRateView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      VStack {
        Spacer()
        SearchCurrencyRateView(
          placeholder: "placeholder",
          currencyRates: [
            .init(currency: .USD, rate: 1.0, lastUpdated: Date()),
            .init(currency: .EUR, rate: 1.0, lastUpdated: Date()),
            .init(currency: .RUB, rate: 1.0, lastUpdated: Date()),
            .init(currency: .RSD, rate: 1.0, lastUpdated: Date()),
            .init(currency: .AED, rate: 1.0, lastUpdated: Date())
          ],
          availableCurrencyRate: [.RUB],
          currencyTypes: [],
          action: { _ in }
        )
        Spacer()
      }
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
