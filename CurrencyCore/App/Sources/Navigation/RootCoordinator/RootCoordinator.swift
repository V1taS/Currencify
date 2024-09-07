//
//  RootCoordinator.swift
//  CurrencyCore
//
//  Created by Vitalii Sosin on 16.04.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions
import SKStyle
import UIKit

final class RootCoordinator: Coordinator<Void, Void> {
  
  // MARK: - Private variables
  
  private var services: IApplicationServices
  private var mainScreenCoordinator: MainScreenCoordinator?
  private var notificationService: INotificationService {
    services.userInterfaceAndExperienceService.notificationService
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(_ services: IApplicationServices) {
    self.services = services
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Internal func
  
  override func start(parameter: Void) {
    Task { @MainActor [weak self] in
      guard let self else { return }
      openMainScreenCoordinator()
    }
  }
}

// MARK: - Open screen

private extension RootCoordinator {
  func openMainScreenCoordinator() {
    let mainScreenCoordinator = MainScreenCoordinator(services)
    self.mainScreenCoordinator = mainScreenCoordinator
    mainScreenCoordinator.finishFlow = { [weak self] _ in
      self?.mainScreenCoordinator = nil
    }
    mainScreenCoordinator.start()
  }
}

// MARK: - Private

private extension RootCoordinator {}
