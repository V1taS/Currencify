//
//  MainScreenPresenter.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SKStyle
import SKUIKit
import SwiftUI
import SKAbstractions

final class MainScreenPresenter: ObservableObject {
  
  // MARK: - View state
  
  @Published var currencyWidgets: [WidgetCryptoView.Model] = []
  @Published var isCurrencyListEmpty = false
  @Published var isSearchViewVisible = false
  @Published var isEditMode: EditMode = .inactive
  @Published var appSettingsModel: AppSettingsModel = .setDefaultValues()
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let factory: MainScreenFactoryInput
  private var rightBarSettingsButton: SKBarButtonItem?
  private var rightBarShareButton: SKBarButtonItem?
  private var leftBarAddButton: SKBarButtonItem?
  private var rawCurrencyRate: String = "0"
  private var currencyRateIdentifiable: [CurrencyRateIdentifiable] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: Интерактор
  ///   - factory: Фабрика
  init(interactor: MainScreenInteractorInput,
       factory: MainScreenFactoryInput) {
    self.interactor = interactor
    self.factory = factory
  }
  
  // MARK: - The lifecycle of a UIViewController
  
  lazy var viewDidLoad: (() -> Void)? = {}
  
  lazy var viewWillAppear: (() -> Void)? = { [weak self] in
    Task { [weak self] in
      guard let self else { return }
      await moduleOutput?.premiumModeCheck()
    }
  }
  
  // MARK: - Internal func
  
  func refreshCurrencyData() async {
    await interactor.fetchCurrencyRates()
    await createCurrencyWidget()
  }
  
  func userAddCurrencyRate(newValue: CurrencyRate) async {
    let appSettingsModel = await getAppSettingsModel()
    isSearchViewVisible = false
    
    if !appSettingsModel.isPremium,
       appSettingsModel.selectedCurrencyRate.count >= 3,
       Secrets.isPremiumMode {
      await moduleOutput?.limitOfAddedCurrenciesHasBeenExceeded()
      return
    }
    
    let newValueArray = [newValue.currency]
    await interactor.setSelectedCurrencyRates(newValueArray)
    await createCurrencyWidget()
  }
  
  func userRemoveCurrencyRate(currencyAlpha: String) async {
    let appSettingsModel = await getAppSettingsModel()
    guard let currency = CurrencyRate.Currency(rawValue: currencyAlpha) else {
      return
    }
    
    if appSettingsModel.activeCurrency == currency {
      await interactor.setUserInputIsVisible(false)
      await interactor.setEnteredCurrencyAmountRaw("0")
      await interactor.setActiveCurrency(appSettingsModel.activeCurrency)
    }
    
    await interactor.removeCurrencyRates([currency])
    await createCurrencyWidget()
  }
  
  @MainActor
  func moveCurrencyRates(from source: IndexSet, to destination: Int) async {
    let appSettingsModel = await getAppSettingsModel()
    
    currencyWidgets.move(fromOffsets: source, toOffset: destination)
    var selectedCurrencyRate = appSettingsModel.selectedCurrencyRate
    selectedCurrencyRate.move(fromOffsets: source, toOffset: destination)
    
    await interactor.removeAllCurrencyRates()
    await interactor.setSelectedCurrencyRates(selectedCurrencyRate)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      Task { [weak self] in
        guard let self else { return }
        await createCurrencyWidget()
      }
    }
  }
  
  @MainActor
  func recalculateCurrencyWidgets() async {
    let appSettingsModel = await getAppSettingsModel()
    
    let currencyRateIdentifiable = await interactor.recalculateCurrencyRates(
      appSettingsModel: appSettingsModel,
      rawCurrencyRate: rawCurrencyRate
    )
    self.currencyRateIdentifiable = currencyRateIdentifiable
    await validateRatesData()
    await setCurrencyRateText()
  }
  
  @MainActor
  func createCurrencyWidget() async {
    let appSettingsModel = await getAppSettingsModel()
    
    rawCurrencyRate = await getEnteredCurrencyAmountRaw(appSettingsModel)
    await recalculateCurrencyWidgets()
    let models = factory.createCurrencyWidgetModels(
      decimalPlaces: appSettingsModel.currencyDecimalPlaces,
      currencyRateIdentifiables: currencyRateIdentifiable
    )
    currencyWidgets = models
    await setCurrencyRateText()
    await setKeyboardIsShown(appSettingsModel.isUserInputVisible, appSettingsModel.activeCurrency)
  }
  
  @MainActor
  func getAppSettingsModel() async -> AppSettingsModel {
    let appSettingsModel = await interactor.getAppSettingsModel()
    self.appSettingsModel = appSettingsModel
    return appSettingsModel
  }
  
  func setUserInputIsVisible(_ value: Bool) async {
    await interactor.setUserInputIsVisible(value)
  }
  
  func setKeyboardIsShown(_ value: Bool, _ currency: CurrencyRate.Currency) async {
    await interactor.setUserInputIsVisible(value)
    
    currencyWidgets.forEach { model in
      let keyboardModelUpdate = model.keyboardModel
      keyboardModelUpdate?.isKeyboardShown = false
      model.keyboardModel = keyboardModelUpdate
    }
    
    if let currencyWidgetsModel = currencyWidgets.first(where: { $0.additionalID == currency.rawValue }),
       let currencyRateIdentifiableModel = currencyRateIdentifiable.first(where: { $0.currency.rawValue == currency.rawValue }) {
      let keyboardModelUpdate = currencyWidgetsModel.keyboardModel
      keyboardModelUpdate?.isKeyboardShown = value
      keyboardModelUpdate?.value = currencyRateIdentifiableModel.rateText
      rawCurrencyRate = currencyRateIdentifiableModel.rateText
      currencyWidgetsModel.keyboardModel = keyboardModelUpdate
    }
  }
}

// MARK: - MainScreenModuleInput

extension MainScreenPresenter: MainScreenModuleInput {}

// MARK: - MainScreenInteractorOutput

extension MainScreenPresenter: MainScreenInteractorOutput {}

// MARK: - MainScreenFactoryOutput

extension MainScreenPresenter: MainScreenFactoryOutput {
  func userDidSelectClearButtonAction() async {
    await userDidEnterAmount("0")
  }
  
  func userDidEnterAmount(_ newValue: String) async {
    let newValue = modifyAmount(newValue)
    let appSettingsModel = await getAppSettingsModel()
    
    await setRawCurrencyRate(newValue: newValue)
    
    let countCharactersAfterComma = interactor.textFormatterService.countCharactersAfterComma(in: newValue)
    if let countCharactersAfterComma, countCharactersAfterComma > appSettingsModel.currencyDecimalPlaces.rawValue {
      triggerHapticFeedback(.error)
    }
    await recalculateCurrencyWidgets()
  }
  
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency) async {
    let appSettingsModel = await getAppSettingsModel()
    
    if appSettingsModel.activeCurrency == currency && appSettingsModel.isUserInputVisible {
      await interactor.setActiveCurrency(currency)
      await setKeyboardIsShown(false, currency)
      await recalculateCurrencyWidgets()
      return
    }
    
    await interactor.setActiveCurrency(currency)
    if let currencyRateIdentifiableModel = currencyRateIdentifiable.first(
        where: {
          $0.currency.rawValue == currency.rawValue
        }
       ) {
      rawCurrencyRate = currencyRateIdentifiableModel.rateText
    }
    
    await saveEnteredCurrencyAmountRaw()
    await setKeyboardIsShown(true, currency)
    await recalculateCurrencyWidgets()
  }
}

// MARK: - SceneViewModel

extension MainScreenPresenter: SceneViewModel {
  var sceneTitle: String? { Constants.title }
  var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode { .always }
  
  var leftBarButtonItems: [SKBarButtonItem] {
    [
      .init(
        .add(
          action: { [weak self] in
            DispatchQueue.main.async { [weak self] in
              self?.isSearchViewVisible = true
            }
          }, buttonItem: { [weak self] buttonItem in
            self?.leftBarAddButton = buttonItem
          }
        )
      )
    ]
  }
  
  var rightBarButtonItems: [SKBarButtonItem] {
    [
      .init(
        .share(
          action: { [weak self] in
            Task { [weak self] in
              guard let self else { return}
              if await interactor.requestGallery() {
                await createCollectionViewSnapshot()
              }
            }
          }, buttonItem: { [weak self] buttonItem in
            self?.rightBarShareButton = buttonItem
          }
        )
      ),
      .init(
        .settings(
          action: { [weak self] in
            DispatchQueue.main.async { [weak self] in
              self?.moduleOutput?.openSettinsScreen()
            }
          }, buttonItem: { [weak self] buttonItem in
            self?.rightBarSettingsButton = buttonItem
          }
        )
      )
    ]
  }
}

// MARK: - Private

private extension MainScreenPresenter {
  @MainActor
  func validateRatesData() async {
    let appSettingsModel = await getAppSettingsModel()
    isCurrencyListEmpty = appSettingsModel.allCurrencyRate.isEmpty
    leftBarAddButton?.isEnabled = !appSettingsModel.allCurrencyRate.isEmpty
    rightBarShareButton?.isEnabled = !appSettingsModel.allCurrencyRate.isEmpty
  }
  
  func createCollectionViewSnapshot() async {
    let finalImage = await interactor.createCollectionViewSnapshot()
    await moduleOutput?.openImageViewer(image: finalImage)
  }
  
  func triggerHapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }
  
  func setCurrencyRateText() async {
    let appSettingsModel = await getAppSettingsModel()
    
    currencyWidgets.forEach { currencyWidgetsModel in
      if let currencyRateIdentifiableModel = currencyRateIdentifiable.first(
        where: {
          $0.currency.rawValue == currencyWidgetsModel.additionalID
        }
      ) {
        let rightSideLargeTextModel = currencyWidgetsModel.rightSideLargeTextModel
        rightSideLargeTextModel?.text = currencyRateIdentifiableModel.rateText
        rightSideLargeTextModel?.textStyle = currencyRateIdentifiableModel.rateDouble == .zero ? .netural : .standart
        currencyWidgetsModel.rightSideLargeTextModel = rightSideLargeTextModel
        
        let keyboardModelUpdate = currencyWidgetsModel.keyboardModel
        keyboardModelUpdate?.value = currencyRateIdentifiableModel.rateText
        currencyWidgetsModel.keyboardModel = keyboardModelUpdate
      }
    }
    
    if let currencyWidgetsModel = currencyWidgets.first(
      where: {
        $0.additionalID == appSettingsModel.activeCurrency.rawValue
      }
    ),
       let currencyRateIdentifiableModel = currencyRateIdentifiable.first(
        where: {
          $0.currency.rawValue == appSettingsModel.activeCurrency.rawValue
        }
       ) {
      let keyboardModelUpdate = currencyWidgetsModel.keyboardModel
      let countCharactersAfterComma = interactor.textFormatterService.countCharactersAfterComma(
        in: currencyRateIdentifiableModel.rateText
      ) ?? .zero
      keyboardModelUpdate?.keyboardIsBlock = countCharactersAfterComma >= appSettingsModel.currencyDecimalPlaces.rawValue
      currencyWidgetsModel.keyboardModel = keyboardModelUpdate
      
      if let keyboardModelUpdate,
         keyboardModelUpdate.isKeyboardShown,
         currencyRateIdentifiableModel.rateDouble != .zero {
        currencyWidgetsModel.isClearButton = true
      } else {
        currencyWidgetsModel.isClearButton = false
      }
    }
  }
  
  func modifyAmount(_ newValue: String) -> String {
    let onlyCommaValue = newValue == "," ? "0," : newValue
    let newValueEmpty = onlyCommaValue.isEmpty ? "0" : onlyCommaValue
    return newValueEmpty
  }
  
  func setRawCurrencyRate(newValue: String) async {
    let newValueReplaceDoubleZeroWithZero = interactor.textFormatterService.replaceDoubleZeroWithZero(in: newValue)
    let newValueRemoveLeadingZeroIfNoComma = interactor.textFormatterService.removeLeadingZeroIfNoComma(
      in: newValueReplaceDoubleZeroWithZero
    )
    
    let rawClearedTextCurrencyRate = interactor.textFormatterService.removeAllSpaces(from: newValueRemoveLeadingZeroIfNoComma)
    let rawThousandsCurrencyRate = interactor.textFormatterService.formatNumberWithThousands(rawClearedTextCurrencyRate)
    rawCurrencyRate = rawThousandsCurrencyRate
    await saveEnteredCurrencyAmountRaw()
  }
  
  func saveEnteredCurrencyAmountRaw() async {
    let newValueRemoveAllSpaces = interactor.textFormatterService.removeAllSpaces(from: rawCurrencyRate)
    let testReplaceCommasWithDots = interactor.textFormatterService.replaceCommasWithDots(in: newValueRemoveAllSpaces)
    await interactor.setEnteredCurrencyAmountRaw(testReplaceCommasWithDots)
  }
  
  func getEnteredCurrencyAmountRaw(_ appSettingsModel: AppSettingsModel) async -> String {
    let enteredCurrencyAmountRaw = appSettingsModel.enteredCurrencyAmountRaw
    let rawReplaceDotsWithCommas = interactor.textFormatterService.replaceDotsWithCommas(in: enteredCurrencyAmountRaw)
    let rawThousandsCurrencyRate = interactor.textFormatterService.formatNumberWithThousands(rawReplaceDotsWithCommas)
    return rawThousandsCurrencyRate
  }
}

// MARK: - Constants

private enum Constants {
  static let title = "Currencify"
}
