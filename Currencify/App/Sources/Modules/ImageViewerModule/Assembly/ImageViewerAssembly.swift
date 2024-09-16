//
//  ImageViewerAssembly.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.09.2024.
//

import SwiftUI
import SKUIKit
import SKAbstractions

/// Сборщик `ImageViewer`
public final class ImageViewerAssembly {
  
  public init() {}
  
  /// Собирает модуль `ImageViewer`
  /// - Returns: Cобранный модуль `ImageViewer`
  public func createModule(
    image: UIImage?,
    services: IApplicationServices
  ) -> ImageViewerModule {
    let interactor = ImageViewerInteractor(services: services)
    let factory = ImageViewerFactory()
    let presenter = ImageViewerPresenter(
      interactor: interactor,
      factory: factory,
      image: image
    )
    let view = ImageViewerView(presenter: presenter)
    let viewController = SceneViewController(viewModel: presenter, content: view)
    
    interactor.output = presenter
    factory.output = presenter
    return (viewController: viewController, input: presenter)
  }
}
