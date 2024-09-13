//
//  PremiumScreenAbstractions.swift
//  Currencify
//
//  Created by Vitalii Sosin on 08.09.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import StoreKit
import SKUIKit
import SKStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol PremiumScreenModuleOutput: AnyObject {

  /// Покупка восстановлена
  func didReceiveRestoredSuccess()

  /// Успешная покупка подписки
  func didReceiveSubscriptionPurchaseSuccess()

  /// Успешная разовая покупка
  func didReceiveOneTimePurchaseSuccess()

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Покупки отсутствуют
  func didReceivePurchasesMissing()
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol PremiumScreenModuleInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter isModalPresentation: Открывается экран снизу вверх
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: PremiumScreenModuleOutput? { get set }
}

/// Готовый модуль `PremiumScreenModule`
typealias PremiumScreenModule = ViewController & PremiumScreenModuleInput
