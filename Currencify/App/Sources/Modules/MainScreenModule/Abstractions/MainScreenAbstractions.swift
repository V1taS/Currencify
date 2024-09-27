//
//  MainScreenAbstractions.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI
import SKAbstractions

/// События которые отправляем из `MainScreenModule` в `Coordinator`
public protocol MainScreenModuleOutput: AnyObject {
  /// Открыть экран настроек
  func openSettinsScreen()
  
  /// Превышен лимит добавленных валют
  func limitOfAddedCurrenciesHasBeenExceeded() async
  
  /// Открыть просмоторщик картинок
  func openImageViewer(image: UIImage?) async
  
  /// Проверить премиум у пользователя
  func premiumModeCheck() async
}

/// События которые отправляем из `Coordinator` в `MainScreenModule`
public protocol MainScreenModuleInput {
  
  /// Создать новые виджеты
  @MainActor
  func createCurrencyWidget() async

  /// События которые отправляем из `MainScreenModule` в `Coordinator`
  var moduleOutput: MainScreenModuleOutput? { get set }
}

/// Готовый модуль `MainScreenModule`
public typealias MainScreenModule = (viewController: UIViewController, input: MainScreenModuleInput)
