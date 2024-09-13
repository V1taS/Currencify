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
  
  @Published var isCurrencyListEmpty = false
  @Published var currencyWidgets: [WidgetCryptoView.Model] = []
  @Published var activeCurrency: CurrencyRate.Currency = .USD
  @Published var isUserInputVisible = false
  @Published var enteredCurrencyAmount: String = "0"
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let factory: MainScreenFactoryInput
  private var rightBarSettingsButton: SKBarButtonItem?
  private var leftBarAddButton: SKBarButtonItem?
  
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
    guard let self else { return }
    setupInitialState()
  }
  
  // MARK: - Internal func
  
  func refreshCurrencyData() {
    interactor.fetchCBCurrencyRates { [weak self] in
      self?.recalculateCurrencyWidgets()
    }
  }
}

// MARK: - MainScreenModuleInput

extension MainScreenPresenter: MainScreenModuleInput {}

// MARK: - MainScreenInteractorOutput

extension MainScreenPresenter: MainScreenInteractorOutput {}

// MARK: - MainScreenFactoryOutput

extension MainScreenPresenter: MainScreenFactoryOutput {
  func userDidEnterAmount(_ amount: String) {
    enteredCurrencyAmount = amount
    recalculateCurrencyWidgets()
  }
  
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency, withRate rate: Double) {
    enteredCurrencyAmount = "\(rate)"
    if activeCurrency == currency && isUserInputVisible {
      isUserInputVisible = false
      recalculateCurrencyWidgets()
      return
    }
    activeCurrency = currency
    isUserInputVisible = true
    recalculateCurrencyWidgets()
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
            // TODO: -
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
  func setupInitialState() {
    recalculateCurrencyWidgets()
  }
  
  func validateRatesData() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      isCurrencyListEmpty = Secrets.currencyRateList.isEmpty || currencyWidgets.isEmpty
      leftBarAddButton?.isEnabled = !Secrets.currencyRateList.isEmpty
    }
  }
  
  func recalculateCurrencyWidgets() {
    interactor.getAppSettingsModel { [weak self] appSettingsModel in
      guard let self else { return }
      
      let calculationMode: RateCalculationMode
      switch appSettingsModel.currencySource {
      case .cbr:
        calculationMode = .inverse
      case .ecb:
        calculationMode = .direct
      }
      let availableRates = appSettingsModel.selectedCurrencyRate
      let models = factory.createCurrencyWidgetModels(
        forCurrency: activeCurrency,
        amountEntered: enteredCurrencyAmount,
        isUserInputActive: isUserInputVisible,
        availableRates: availableRates,
        rateCalculationMode: calculationMode,
        decimalPlaces: appSettingsModel.currencyDecimalPlaces
      )
      currencyWidgets = models
      validateRatesData()
    }
  }
}

// MARK: - Constants

private enum Constants {
  static let title = "Currency"
}
