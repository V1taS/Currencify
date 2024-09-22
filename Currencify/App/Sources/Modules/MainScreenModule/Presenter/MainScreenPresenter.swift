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
  @Published var availableCurrencyRate: [CurrencyRate.Currency] = []
  @Published var currencyTypes: [CurrencyRate.CurrencyType] = []
  @Published var isCurrencyListEmpty = false
  @Published var isUserInputVisible = false
  @Published var isSearchViewVisible = false
  @Published var isEditMode: EditMode = .inactive
  @Published var activeCurrency: CurrencyRate.Currency = .USD
  @Published var allCurrencyRate: [CurrencyRate] = []
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let factory: MainScreenFactoryInput
  private var rightBarSettingsButton: SKBarButtonItem?
  private var rightBarShareButton: SKBarButtonItem?
  private var leftBarAddButton: SKBarButtonItem?
  
  private var enteredCurrencyAmount: Double = .zero
  private var commaIsSet = false
  
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
  
  lazy var viewDidLoad: (() -> Void)? = { [weak self] in
    Task { [weak self] in
      guard let self else { return }
      await setupInitialState()
    }
  }
  
  lazy var viewWillAppear: (() -> Void)? = { [weak self] in
    self?.moduleOutput?.viewWillAppear()
  }
  
  // MARK: - Internal func
  
  func refreshCurrencyData() async {
    await interactor.fetchCurrencyRates()
    await recalculateCurrencyWidgets()
  }
  
  func userAddCurrencyRate(newValue: CurrencyRate) async {
    let appSettingsModel = await interactor.getAppSettingsModel()
    isSearchViewVisible = false
    
    if !appSettingsModel.isPremium,
       appSettingsModel.selectedCurrencyRate.count >= 3,
       Secrets.isPremiumMode {
      await moduleOutput?.limitOfAddedCurrenciesHasBeenExceeded()
      return
    }
    
    await interactor.setSelectedCurrencyRates([newValue.currency])
    await recalculateCurrencyWidgets()
  }
  
  func userRemoveCurrencyRate(currencyAlpha: String) async {
    guard let currency = CurrencyRate.Currency(rawValue: currencyAlpha) else {
      return
    }
    
    if activeCurrency == currency {
      isUserInputVisible = false
      enteredCurrencyAmount = .zero
      await interactor.setEnteredCurrencyAmount(.zero)
      let appSettingsModel = await interactor.getAppSettingsModel()
      let filteredCurrencies = appSettingsModel.selectedCurrencyRate.filter { $0 != currency }
      activeCurrency = filteredCurrencies.first ?? .USD
      await interactor.setActiveCurrency(activeCurrency)
    }
    
    await interactor.removeCurrencyRates([currency])
    await recalculateCurrencyWidgets()
  }
  
  @MainActor
  func moveCurrencyRates(from source: IndexSet, to destination: Int) async {
    currencyWidgets.move(fromOffsets: source, toOffset: destination)
    let appSettingsModel = await interactor.getAppSettingsModel()
    var selectedCurrencyRate = appSettingsModel.selectedCurrencyRate
    selectedCurrencyRate.move(fromOffsets: source, toOffset: destination)
    await interactor.removeAllCurrencyRates()
    await interactor.setSelectedCurrencyRates(selectedCurrencyRate)
  }
  
  @MainActor
  func recalculateCurrencyWidgets() async {
    let appSettingsModel = await interactor.getAppSettingsModel()
    availableCurrencyRate = appSettingsModel.selectedCurrencyRate
    currencyTypes = appSettingsModel.currencyTypes
    enteredCurrencyAmount = appSettingsModel.enteredCurrencyAmount
    activeCurrency = appSettingsModel.activeCurrency
    
    let availableRates = appSettingsModel.selectedCurrencyRate
    let models = factory.createCurrencyWidgetModels(
      forCurrency: activeCurrency,
      amountEntered: enteredCurrencyAmount,
      isUserInputActive: isUserInputVisible,
      availableRates: availableRates,
      rateCalculationMode: .inverse,
      decimalPlaces: appSettingsModel.currencyDecimalPlaces,
      commaIsSet: commaIsSet,
      rateCorrectionPercentage: appSettingsModel.rateCorrectionPercentage, 
      allCurrencyRate: appSettingsModel.allCurrencyRate,
      currencyTypes: appSettingsModel.currencyTypes
    )
    currencyWidgets = models
    allCurrencyRate = appSettingsModel.allCurrencyRate
    await validateRatesData()
  }
}

// MARK: - MainScreenModuleInput

extension MainScreenPresenter: MainScreenModuleInput {}

// MARK: - MainScreenInteractorOutput

extension MainScreenPresenter: MainScreenInteractorOutput {}

// MARK: - MainScreenFactoryOutput

extension MainScreenPresenter: MainScreenFactoryOutput {
  func userDidEnterAmount(_ amount: Double, commaIsSet: Bool) async {
    self.commaIsSet = commaIsSet
    enteredCurrencyAmount = amount
    await interactor.setEnteredCurrencyAmount(amount)
    await recalculateCurrencyWidgets()
  }
  
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency, withRate rate: Double) async {
    enteredCurrencyAmount = rate
    await interactor.setEnteredCurrencyAmount(rate)
    if activeCurrency == currency && isUserInputVisible {
      isUserInputVisible = false
      await interactor.setActiveCurrency(currency)
      await recalculateCurrencyWidgets()
      return
    }
    activeCurrency = currency
    isUserInputVisible = true
    await interactor.setActiveCurrency(currency)
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
            self?.isSearchViewVisible = true
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
            self?.moduleOutput?.openSettinsScreen()
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
  func setupInitialState() async {}
  
  @MainActor
  func validateRatesData() async {
    let appSettingsModel = await interactor.getAppSettingsModel()
    isCurrencyListEmpty = appSettingsModel.allCurrencyRate.isEmpty || currencyWidgets.isEmpty
    leftBarAddButton?.isEnabled = !appSettingsModel.allCurrencyRate.isEmpty
    rightBarShareButton?.isEnabled = !appSettingsModel.allCurrencyRate.isEmpty
  }
  
  func createCollectionViewSnapshot() async {
    let finalImage = await interactor.createCollectionViewSnapshot()
    await moduleOutput?.openImageViewer(image: finalImage)
  }
}

// MARK: - Constants

private enum Constants {
  static let title = "Currencify"
}
