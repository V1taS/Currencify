//
//  ImageViewerFactory.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.09.2024.
//

import SwiftUI

/// Cобытия которые отправляем из Factory в Presenter
protocol ImageViewerFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ImageViewerFactoryInput {}

/// Фабрика
final class ImageViewerFactory {
  
  // MARK: - Internal properties
  
  weak var output: ImageViewerFactoryOutput?
}

// MARK: - ImageViewerFactoryInput

extension ImageViewerFactory: ImageViewerFactoryInput {}

// MARK: - Private

private extension ImageViewerFactory {}

// MARK: - Constants

private enum Constants {}
