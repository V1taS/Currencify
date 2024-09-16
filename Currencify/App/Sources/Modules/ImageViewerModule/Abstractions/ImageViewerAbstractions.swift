//
//  ImageViewerAbstractions.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.09.2024.
//

import SwiftUI

/// События которые отправляем из `ImageViewerModule` в `Coordinator`
public protocol ImageViewerModuleOutput: AnyObject {
  /// Закрыть модуль просмотра картинок
  func imageViewerModuleClosed()
}

/// События которые отправляем из `Coordinator` в `ImageViewerModule`
public protocol ImageViewerModuleInput {

  /// События которые отправляем из `ImageViewerModule` в `Coordinator`
  var moduleOutput: ImageViewerModuleOutput? { get set }
}

/// Готовый модуль `ImageViewerModule`
public typealias ImageViewerModule = (viewController: UIViewController, input: ImageViewerModuleInput)
