//
//  SettingsScreenAbstractions.swift
//  Currencify
//
//  Created by Vitalii Sosin on 21.04.2024.
//

import SwiftUI

/// События которые отправляем из `SettingsScreenModule` в `Coordinator`
public protocol SettingsScreenModuleOutput: AnyObject {  
  /// Открыть экран настроек внешнего вида
  func openAppearanceSection()
  
  /// Открыть экран настроек языка
  func openLanguageSection()
  
  /// Пользователь выбрал обратную связь
  func userSelectFeedBack()
  
  /// Пользователь выбрал Премиум
  func userSelectPremium()
  
  /// Пользователь выбрал отредактировать курс
  func userSelectEditRate()
}

/// События которые отправляем из `Coordinator` в `SettingsScreenModule`
public protocol SettingsScreenModuleInput {
  
  /// Удалить все данные из основной модели
  @discardableResult
  func deleteAllData() async -> Bool

  /// События которые отправляем из `SettingsScreenModule` в `Coordinator`
  var moduleOutput: SettingsScreenModuleOutput? { get set }
}

/// Готовый модуль `SettingsScreenModule`
public typealias SettingsScreenModule = (viewController: UIViewController, input: SettingsScreenModuleInput)
