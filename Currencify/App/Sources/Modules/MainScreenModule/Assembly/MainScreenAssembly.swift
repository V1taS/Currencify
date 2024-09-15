//
//  MainScreenAssembly.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI
import SKUIKit
import SKAbstractions

/// Сборщик `MainScreen`
public final class MainScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `MainScreen`
  /// - Returns: Cобранный модуль `MainScreen`
  public func createModule(services: IApplicationServices) -> MainScreenModule {
    let interactor = MainScreenInteractor(services: services)
    let factory = MainScreenFactory(textFormatterService: services.textFormatterService)
    let presenter = MainScreenPresenter(
      interactor: interactor,
      factory: factory
    )
    let view = MainScreenView(presenter: presenter)
    let viewController = SceneViewController(viewModel: presenter, content: view)
    
    interactor.output = presenter
    factory.output = presenter
    return (viewController: viewController, input: presenter)
  }
}
