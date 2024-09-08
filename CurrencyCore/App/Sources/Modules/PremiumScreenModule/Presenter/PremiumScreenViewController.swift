//
//  PremiumScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import StoreKit
import SKAbstractions
import SKUIKit
import SKStyle

/// Презентер
final class PremiumScreenViewController: PremiumScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: PremiumScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: PremiumScreenInteractorInput
  private let moduleView: PremiumScreenViewProtocol
  private let factory: PremiumScreenFactoryInput
  private var cacheIsModalPresentation = false
  private var cacheModels: [SKProduct] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: PremiumScreenViewProtocol,
       interactor: PremiumScreenInteractorInput,
       factory: PremiumScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    factory.createListModelWith(models: [])
    navigationItem.largeTitleDisplayMode = .never
    setNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    interactor.getProducts()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool) {
    cacheIsModalPresentation = isModalPresentation
  }
}

// MARK: - PremiumScreenViewOutput

extension PremiumScreenViewController: PremiumScreenViewOutput {
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType) {
    interactor.mainButtonAction(purchaseType)
  }
  
  func restorePurchaseButtonAction() {
    interactor.restorePurchase()
  }
  
  func didChangePageAction() {
    // TODO: -
  }
  
  func monthlySubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func annualSubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func lifetimeAccessCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
}

// MARK: - PremiumScreenInteractorOutput

extension PremiumScreenViewController: PremiumScreenInteractorOutput {
  func didReceiveSubscriptionPurchaseSuccess() {
    moduleOutput?.didReceiveSubscriptionPurchaseSuccess()
  }

  func didReceiveOneTimePurchaseSuccess() {
    moduleOutput?.didReceiveOneTimePurchaseSuccess()
  }

  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
  }

  func didReceivePurchasesMissing() {
    moduleOutput?.didReceivePurchasesMissing()
  }
  
  func didReceiveRestoredSuccess() {
    moduleOutput?.didReceiveRestoredSuccess()
  }
  
  func startPaymentProcessing() {
    moduleView.startLoader()
  }
  
  func stopPaymentProcessing() {
    moduleView.stopLoader()
  }
  
  func didReceive(models: [SKProduct]) {
    cacheModels = models
    factory.createListModelWith(models: models)
  }
}

// MARK: - PremiumScreenFactoryOutput

extension PremiumScreenViewController: PremiumScreenFactoryOutput {
  func didReceiveMainButton(title: String?) {
    moduleView.updateButtonWith(title: title)
  }
  
  func didReceive(models: [PremiumScreenSectionType]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Private

private extension PremiumScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    if cacheIsModalPresentation {
      let closeButton = UIBarButtonItem(image: appearance.closeButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(closeButtonAction))
      
      navigationItem.rightBarButtonItems = [closeButton]
    }
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
  }
}

// MARK: - SKProduct

private extension SKProduct {
  var localizedPrice: String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = priceLocale
    numberFormatter.numberStyle = .currency
    return numberFormatter.string(from: price)
  }
}

// MARK: - Appearance

private extension PremiumScreenViewController {
  struct Appearance {
    let title = CurrencyCoreStrings.PremiumScreenLocalization.premium
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
