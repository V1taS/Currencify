//
//  SettingsScreenFactory.swift
//  Currencify
//
//  Created by Vitalii Sosin on 21.04.2024.
//

import SwiftUI
import SKUIKit
import SKStyle
import SKAbstractions

/// Cобытия которые отправляем из Factory в Presenter
protocol SettingsScreenFactoryOutput: AnyObject {
  /// Открыть экран настроек внешнего вида
  func openAppearanceSection()
  
  /// Открыть экран настроек языка
  func openLanguageSection()
  
  /// Пользователь выбрал обратную связь
  func userSelectFeedBack()
  
  /// Пользователь выбрал Премиум
  func userSelectPremium()
  
  /// Кнопка поделиться была нажата
  func shareButtonSelected()
  
  /// Пользователь выбрал Премиум
  func userSelectMaxFraction(_ fraction: Int) async
  
  /// Пользователь выбрал Источник загрузки курсов валют
  func userSelectCurrencyRateSource(_ rateSource: Int) async
  
  /// Была сделана корекция текущего курса
  func didChangeRateCorrectionPercentage(_ value: Double) async
}

/// Cобытия которые отправляем от Presenter к Factory
protocol SettingsScreenFactoryInput {
  /// Создать заголовок для экрана
  func createHeaderTitle() -> String
  
  /// Создать верхнюю секцию
  func createTopWidgetModels(
    _ appSettingsModel: AppSettingsModel,
    languageValue: String
  ) -> [WidgetCryptoView.Model]
  
  /// Создать верхнюю секцию
  func createBottomWidgetModels(
    _ appSettingsModel: AppSettingsModel,
    premiumState: String
  ) -> [WidgetCryptoView.Model]
  
  /// Создаем заголовок, какой язык выбран в приложении Русский или Английский
  func createLanguageValue(from languageType: AppLanguageType) -> String
}

/// Фабрика
final class SettingsScreenFactory {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenFactoryOutput?
}

// MARK: - SettingsScreenFactoryInput

extension SettingsScreenFactory: SettingsScreenFactoryInput {
  func createLanguageValue(from languageType: SKAbstractions.AppLanguageType) -> String {
    switch languageType {
    case .english:
      return CurrencifyStrings.SettingsScreenLocalization
        .State.LanguageType.English.title
    case .russian:
      return  CurrencifyStrings.SettingsScreenLocalization
        .State.LanguageType.Russian.title
    }
  }
  
  func createHeaderTitle() -> String {
    return CurrencifyStrings.SettingsScreenLocalization
      .State.Header.title
  }
  
  func createTopWidgetModels(
    _ appSettingsModel: AppSettingsModel,
    languageValue: String
  ) -> [WidgetCryptoView.Model] {
    var models: [WidgetCryptoView.Model] = []
    
    let appearanceModel = createWidgetWithChevron(
      image: Image(systemName: "applepencil.and.scribble"),
      backgroundColor: #colorLiteral(red: 0.9988374114, green: 0.6133651733, blue: 0.03555859998, alpha: 1),
      title: CurrencifyStrings.SettingsScreenLocalization
        .State.Appearance.title,
      action: { [weak self] in
        self?.output?.openAppearanceSection()
      }
    )
    models.append(appearanceModel)
    
    let languageModel = createWidgetWithChevron(
      image: Image(systemName: "globe"),
      backgroundColor: #colorLiteral(red: 0.02118782885, green: 0.6728788018, blue: 0.6930519938, alpha: 1),
      title: CurrencifyStrings.SettingsScreenLocalization
        .State.Language.title,
      additionRightTitle: languageValue,
      action: { [weak self] in
        self?.output?.openLanguageSection()
      }
    )
    models.append(languageModel)
    
    let feedbackModel = createWidgetWithChevron(
      image: Image(systemName: "pencil"),
      backgroundColor: #colorLiteral(red: 0.6352941176, green: 0.5176470588, blue: 0.368627451, alpha: 1),
      title: CurrencifyStrings.SettingsScreenLocalization.Feedback.title,
      action: { [weak self] in
        self?.output?.userSelectFeedBack()
      }
    )
    models.append(feedbackModel)
    
    let shareModel = createWidgetWithChevron(
      image: Image(systemName: "square.and.arrow.up"),
      backgroundColor: #colorLiteral(red: 0.2063956261, green: 0.5307067633, blue: 0.2265998721, alpha: 1),
      title: CurrencifyStrings.SettingsScreenLocalization.share,
      action: { [weak self] in
        self?.output?.shareButtonSelected()
      }
    )
    models.append(shareModel)
    return models
  }
  
  func createBottomWidgetModels(
    _ appSettingsModel: AppSettingsModel,
    premiumState: String
  ) -> [WidgetCryptoView.Model] {
    var models: [WidgetCryptoView.Model] = []
    
    let lastUpdated = appSettingsModel.allCurrencyRate.first?.lastUpdated ?? Date()
    let availableInPremiumOnly = CurrencifyStrings.SettingsScreenLocalization
      .AvailableInPremiumOnly.title
    let editRateDescription = CurrencifyStrings.SettingsScreenLocalization.EditRate.description
    let editRateDescriptionNonPremium = "\(editRateDescription) \n\n\(availableInPremiumOnly)"
    let isPremium = appSettingsModel.isPremium
    
    let premiumModel = createWidgetWithChevron(
      image: Image(systemName: "star.fill"),
      backgroundColor: #colorLiteral(red: 0.8638121486, green: 0.2361198068, blue: 0.8861094117, alpha: 1),
      title: CurrencifyStrings.SettingsScreenLocalization.Premium.title,
      additionRightTitle: premiumState,
      action: { [weak self] in
        self?.output?.userSelectPremium()
      }
    )
    models.append(premiumModel)
    
    let editRateModel = createEditRateModel(
      title: CurrencifyStrings.SettingsScreenLocalization.EditRate.title,
      description: isPremium ? editRateDescription : editRateDescriptionNonPremium,
      rateCorrectionPercentage: appSettingsModel.rateCorrectionPercentage,
      isPremium: isPremium,
      actionSlider: { [weak self] newValue in
        Task { [weak self] in
          await self?.output?.didChangeRateCorrectionPercentage(newValue)
        }
      },
      action: { [weak self] in
        self?.output?.userSelectPremium()
      }
    )
    models.append(editRateModel)
    
    let maxFractionModel = createSegmentedPickerModel(
      title: CurrencifyStrings.SettingsScreenLocalization
        .MaxFraction.title,
      description: isPremium ? nil : availableInPremiumOnly,
      selectedSegment: appSettingsModel.currencyDecimalPlaces.rawValue,
      segments: CurrencyDecimalPlaces.allCases.compactMap({ $0.rawValue }),
      isPremium: isPremium, 
      actionSegmented: { [weak self] newValue in
        Task { [weak self] in
          await self?.output?.userSelectMaxFraction(newValue)
        }
      },
      action: { [weak self] in
        self?.output?.userSelectPremium()
      }
    )
    models.append(maxFractionModel)
    
    let currencyRateSourceModel = createSegmentedPickerModel(
      title: CurrencifyStrings.SettingsScreenLocalization
        .CurrencyRateSource.title,
      description: isPremium ? CurrencifyStrings.SettingsScreenLocalization
        .LastUpdated.title("\(formatDate(lastUpdated))") : availableInPremiumOnly,
      selectedSegment: appSettingsModel.currencySource.rawValue,
      segments: CurrencySource.allCases.compactMap({ $0.description }),
      isPremium: isPremium, 
      actionSegmented: { [weak self] newValue in
        Task { [weak self] in
          await self?.output?.userSelectCurrencyRateSource(newValue)
        }
      },
      action: { [weak self] in
        self?.output?.userSelectPremium()
      }
    )
    models.append(currencyRateSourceModel)
    
    return models
  }
}

// MARK: - Private

private extension SettingsScreenFactory {
  func createEditRateModel(
    title: String,
    description: String?,
    rateCorrectionPercentage: Double,
    isPremium: Bool,
    actionSlider: @escaping (Double) -> Void,
    action: @escaping () -> Void
  ) -> WidgetCryptoView.Model {
    .init(
      leftSide: nil,
      additionCenterContent: AnyView(
        VStack {
          HStack {
            Text(title)
              .font(.fancy.text.regular)
              .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
              .lineLimit(1)
              .multilineTextAlignment(.leading)
              .allowsHitTesting(false)
            Spacer()
          }
          
          CompactSliderView(
            value: rateCorrectionPercentage,
            isEnabled: isPremium) { newValue in
              actionSlider(newValue)
            }
          
          if let description {
            HStack {
              Text(description)
                .font(.fancy.text.small)
                .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
                .lineLimit(.max)
                .multilineTextAlignment(.leading)
                .allowsHitTesting(false)
              Spacer()
            }
          }
        }
          .padding(.bottom, .s1)
      ),
      isSelectable: !isPremium,
      action: action
    )
  }
  
  func createSegmentedPickerModel<Element: Collection>(
    title: String,
    description: String?,
    selectedSegment: Int,
    segments: Element,
    isPremium: Bool,
    actionSegmented: @escaping (Int) -> Void,
    action: @escaping () -> Void
  ) -> WidgetCryptoView.Model where Element.Element: CustomStringConvertible {
    .init(
      leftSide: nil,
      rightSide: nil,
      additionCenterContent: AnyView(
        VStack {
          HStack {
            Text(title)
              .font(.fancy.text.regular)
              .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
              .lineLimit(1)
              .multilineTextAlignment(.leading)
              .allowsHitTesting(false)
            Spacer()
          }
          
          SegmentedPickerView(
            selectedSegment: selectedSegment,
            segments: segments,
            isEnabled: isPremium,
            action: actionSegmented
          )
          
          if let description {
            HStack {
              Text(description)
                .font(.fancy.text.small)
                .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .allowsHitTesting(false)
              Spacer()
            }
          }
        }
          .padding(.bottom, .s1)
      ),
      isSelectable: !isPremium,
      action: action
    )
  }
  
  func createWidgetWithChevron(
    image: Image,
    backgroundColor: UIColor,
    title: String,
    additionRightTitle: String? = nil,
    action: (() -> Void)?
  ) -> WidgetCryptoView.Model {
    var textModel: WidgetCryptoView.TextModel?
    if let additionRightTitle {
      textModel = .init(text: additionRightTitle, textStyle: .netural)
    }
    
    return .init(
      leftSide: .init(
        itemModel: .custom(
          item: AnyView(
            Color(backgroundColor)
              .clipShape(RoundedRectangle(cornerRadius: .s2 / 1.3))
              .overlay {
                image
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(height: .s5)
                  .foregroundColor(SKStyleAsset.constantGhost.swiftUIColor)
                  .allowsHitTesting(false)
              }
          ),
          size: .custom(width: .s8, height: .s8),
          isHitTesting: false
        ),
        titleModel: nil,
        descriptionModel: .init(text: title, textStyle: .standart)
      ),
      rightSide: .init(
        imageModel: .chevron,
        titleModel: nil,
        descriptionModel: textModel
      ),
      action: action
    )
  }
  
  func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }
}

// MARK: - Constants

private enum Constants {}
