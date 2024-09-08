//
//  PremiumScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import StoreKit
import ApphudSDK
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol PremiumScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: Результат генерации для таблички
  func didReceive(models: [SKProduct])
  
  /// Покупка восстановлена
  func didReceiveRestoredSuccess()
  
  /// Успешная покупка подписки
  func didReceiveSubscriptionPurchaseSuccess()
  
  /// Успешная разовая покупка
  func didReceiveOneTimePurchaseSuccess()
  
  /// Начало оплаты
  func startPaymentProcessing()
  
  /// Конец оплаты
  func stopPaymentProcessing()
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Покупки отсутствуют
  func didReceivePurchasesMissing()
}

/// События которые отправляем от Presenter к Interactor
protocol PremiumScreenInteractorInput {
  
  /// Получить продукт от Аппл
  func getProducts()
  
  /// Основная кнопка была нажата
  /// - Parameter purchaseType: Тип платной услуги
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType)
  
  /// Восстановить покупки
  func restorePurchase()
}

/// Интерактор
final class PremiumScreenInteractor: PremiumScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let appPurchasesService: IAppPurchasesService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  init(services: IApplicationServices) {
    self.appPurchasesService = services.appPurchasesService
  }
  
  // MARK: - Internal func
  
  func restorePurchase() {
    output?.startPaymentProcessing()
    appPurchasesService.restorePurchase { [weak self] isValidate in
      self?.output?.stopPaymentProcessing()
      
      switch isValidate {
      case true:
        self?.output?.didReceiveRestoredSuccess()
      case false:
        self?.output?.didReceivePurchasesMissing()
      }
    }
  }
  
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType) {
    output?.startPaymentProcessing()
    
    appPurchasesService.purchaseWith(purchaseType.productIdentifiers) { [weak self] result in
      switch result {
      case .successfulSubscriptionPurchase:
        self?.output?.didReceiveSubscriptionPurchaseSuccess()
      case .successfulOneTimePurchase:
        self?.output?.didReceiveOneTimePurchaseSuccess()
      case .somethingWentWrong:
        self?.output?.somethingWentWrong()
      }
      self?.output?.stopPaymentProcessing()
    }
  }
  
  func getProducts() {
    appPurchasesService.getProducts { [weak self] skProducts in
      self?.output?.didReceive(models: skProducts)
    }
  }
}

// MARK: - Private

private extension PremiumScreenInteractor {}

// MARK: - Appearance

private extension PremiumScreenInteractor {
  struct Appearance {}
}
