//
//  MainScreenInteractor.swift
//  CurrencyCore
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI

/// События которые отправляем из Interactor в Presenter
protocol MainScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {}

/// Интерактор
final class MainScreenInteractor {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
}

// MARK: - MainScreenInteractorInput

extension MainScreenInteractor: MainScreenInteractorInput {}

// MARK: - Private

private extension MainScreenInteractor {}

// MARK: - Constants

private enum Constants {}
