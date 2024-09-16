//
//  ImageViewerPresenter.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.09.2024.
//

import SKStyle
import SKUIKit
import SwiftUI

final class ImageViewerPresenter: ObservableObject {
  
  // MARK: - View state
  
  @Published var finalImage: UIImage?
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ImageViewerModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ImageViewerInteractorInput
  private let factory: ImageViewerFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: Интерактор
  ///   - factory: Фабрика
  init(interactor: ImageViewerInteractorInput,
       factory: ImageViewerFactoryInput,
       image: UIImage?) {
    self.interactor = interactor
    self.factory = factory
    self.finalImage = image
  }
  
  // MARK: - The lifecycle of a UIViewController
  
  lazy var viewDidLoad: (() -> Void)? = {}
  
  // MARK: - Internal func
  
  @MainActor
  func saveImageToGallery() async {
    guard let finalImage else { return }
    await interactor.saveImageToGallery(finalImage.pngData())
    moduleOutput?.imageViewerModuleClosed()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.interactor.showNotification(
        .positive(
          title: CurrencifyStrings.ImageViewerLocalization
            .Notifications.saved
        )
      )
    }
  }
}

// MARK: - ImageViewerModuleInput

extension ImageViewerPresenter: ImageViewerModuleInput {}

// MARK: - ImageViewerInteractorOutput

extension ImageViewerPresenter: ImageViewerInteractorOutput {}

// MARK: - ImageViewerFactoryOutput

extension ImageViewerPresenter: ImageViewerFactoryOutput {}

// MARK: - SceneViewModel

extension ImageViewerPresenter: SceneViewModel {}

// MARK: - Private

private extension ImageViewerPresenter {}

// MARK: - Constants

private enum Constants {}
