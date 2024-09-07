//
//  MainScreenFactory.swift
//  CurrencyCore
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SwiftUI

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {}

/// Фабрика
final class MainScreenFactory {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
}

// MARK: - MainScreenFactoryInput

extension MainScreenFactory: MainScreenFactoryInput {}

// MARK: - Private

private extension MainScreenFactory {}

// MARK: - Constants

private enum Constants {}
