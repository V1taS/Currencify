//
//  SettingsScreenPresenter.swift
//  Currencify
//
//  Created by Vitalii Sosin on 21.04.2024.
//

import SKStyle
import SKUIKit
import SwiftUI
import SKAbstractions

final class SettingsScreenPresenter: ObservableObject {
  
  // MARK: - View state
  
  /// Язык в приложении
  @Published var stateCurrentLanguage: AppLanguageType = .english
  @Published var stateTopWidgetModels: [WidgetCryptoView.Model] = []
  @Published var stateBottomWidgetModels: [WidgetCryptoView.Model] = []
  
  // MARK: - Internal properties
  
  weak var moduleOutput: SettingsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: SettingsScreenInteractorInput
  private let factory: SettingsScreenFactoryInput
  private var premiumState: String = ""
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: Интерактор
  ///   - factory: Фабрика
  init(interactor: SettingsScreenInteractorInput,
       factory: SettingsScreenFactoryInput) {
    self.interactor = interactor
    self.factory = factory
  }
  
  // MARK: - The lifecycle of a UIViewController
  
  lazy var viewDidLoad: (() -> Void)? = {}
  
  lazy var viewWillAppear: (() -> Void)? = { [weak self] in
    Task { [weak self] in
      await self?.updateContent()
    }
  }
  
  // MARK: - Internal func
  
  func getAplicationVersion() -> String {
    let appVersion = interactor.getAppVersion()
    let versionTitle = CurrencifyStrings.SettingsScreenLocalization
      .State.Version.title
    return "\(versionTitle) \(appVersion)"
  }
}

// MARK: - SettingsScreenModuleInput

extension SettingsScreenPresenter: SettingsScreenModuleInput {
  func deleteAllData() async -> Bool {
    return await interactor.deleteAllData()
  }
}

// MARK: - SettingsScreenInteractorOutput

extension SettingsScreenPresenter: SettingsScreenInteractorOutput {}

// MARK: - SettingsScreenFactoryOutput

extension SettingsScreenPresenter: SettingsScreenFactoryOutput {
  func didChangeCryptoCurrency(_ isEnabled: Bool) async {
    if isEnabled {
      await interactor.setCurrencyTypes([.crypto])
    } else {
      await interactor.removeCurrencyTypes([.crypto])
    }
    await updateContent()
  }
  
  func shareButtonSelected() {
    moduleOutput?.shareButtonSelected()
  }
  
  func didChangeRateCorrectionPercentage(_ value: Double) async {
    await interactor.setRateCorrectionPercentage(value)
  }
  
  @MainActor
  func userSelectMaxFraction(_ fraction: Int) async {
    await interactor.setCurrencyDecimalPlaces(CurrencyDecimalPlaces(rawValue: fraction) ?? .zero)
    await updateContent()
  }
  
  func userSelectPremium() {
    moduleOutput?.userSelectPremium()
  }
  
  func userSelectFeedBack() {
    moduleOutput?.userSelectFeedBack()
  }
  
  func openAppearanceSection() {
    moduleOutput?.openAppearanceSection()
  }
  
  func openLanguageSection() {
    moduleOutput?.openLanguageSection()
  }
}

// MARK: - SceneViewModel

extension SettingsScreenPresenter: SceneViewModel {
  var sceneTitle: String? {
    factory.createHeaderTitle()
  }
  
  var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
    .always
  }
}

// MARK: - Private

private extension SettingsScreenPresenter {
  @MainActor
  func updateContent() async {
    await getPremiumActivatedState()
    stateCurrentLanguage = interactor.getCurrentLanguage()
    let appSettingsModel = await interactor.getAppSettingsModel()
    let languageValue = factory.createLanguageValue(from: stateCurrentLanguage)
    
    stateTopWidgetModels = factory.createTopWidgetModels(
      appSettingsModel,
      languageValue: languageValue
    )
    stateBottomWidgetModels = factory.createBottomWidgetModels(
      appSettingsModel,
      premiumState: premiumState,
      isEnabledCryptoCurrency: appSettingsModel.currencyTypes.contains(.crypto)
    )
  }
  
  func getPremiumActivatedState() async {
    let isPremium = await interactor.getIsPremiumState()
    
    if isPremium {
      premiumState = CurrencifyStrings.SettingsScreenLocalization.Premium.activated
    } else {
      premiumState = CurrencifyStrings.SettingsScreenLocalization.Premium.notActivated
    }
  }
}

// MARK: - Constants

private enum Constants {}
