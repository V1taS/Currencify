//
//  ImageViewerInteractor.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.09.2024.
//

import SwiftUI
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol ImageViewerInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol ImageViewerInteractorInput {
  /// Сохраняет изображение в галерее устройства.
  /// - Parameters:
  ///   - imageData: Данные изображения в формате `Data?`. Если передается `nil`, изображение не будет сохранено.
  ///   - return: `Bool`, указывающий успешно ли было сохранение изображения.
  @discardableResult
  func saveImageToGallery(_ imageData: Data?) async -> Bool
  
  /// Показать уведомление
  /// - Parameters:
  ///   - type: Тип уведомления
  func showNotification(_ type: NotificationServiceType)
}

/// Интерактор
final class ImageViewerInteractor {
  
  // MARK: - Internal properties
  
  weak var output: ImageViewerInteractorOutput?
  
  // MARK: - Private properties
  
  private let uiService: IUIService
  private let notificationService: INotificationService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  init(services: IApplicationServices) {
    uiService = services.userInterfaceAndExperienceService.uiService
    notificationService = services.userInterfaceAndExperienceService.notificationService
  }
}

// MARK: - ImageViewerInteractorInput

extension ImageViewerInteractor: ImageViewerInteractorInput {
  func saveImageToGallery(_ imageData: Data?) async -> Bool {
    await uiService.saveImageToGallery(imageData)
  }
  
  func showNotification(_ type: SKAbstractions.NotificationServiceType) {
    notificationService.showNotification(type)
  }
}

// MARK: - Private

private extension ImageViewerInteractor {}

// MARK: - Constants

private enum Constants {}
