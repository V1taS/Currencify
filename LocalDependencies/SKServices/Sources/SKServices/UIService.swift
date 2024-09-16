//
//  UIService.swift
//  SKServices
//
//  Created by Vitalii Sosin on 21.03.2024.
//

import SwiftUI
import SKAbstractions
import SKStyle
import CoreImage.CIFilterBuiltins
import SKFoundation

// MARK: - UIService

public final class UIService: IUIService {
  
  // MARK: - Private properties
  
  private lazy var mediaSaver = MediaToGallerySaver()
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Public func
  
  public func saveColorScheme(_ interfaceStyle: UIUserInterfaceStyle?) {
    if let interfaceStyle {
      let isDarkMode = interfaceStyle == .dark
      UserDefaults.standard.set(isDarkMode, forKey: Constants.colorSchemeKey)
    } else {
      UserDefaults.standard.removeObject(forKey: Constants.colorSchemeKey)
    }
  }
  
  public func getColorScheme() -> UIUserInterfaceStyle? {
    guard let isDarkMode = (UserDefaults.standard.object(forKey: Constants.colorSchemeKey) as? Bool) else {
      return nil
    }
    return isDarkMode ? .dark : .light
  }
  
  public func generateQRCode(
    from string: String,
    iconIntoQR: UIImage?,
    completion: ((UIImage?) -> Void)?
  ) {
    generateQRCode(
      from: string,
      backgroundColor: .clear,
      foregroundColor: SKStyleAsset.constantNavy.swiftUIColor,
      iconIntoQR: iconIntoQR,
      iconSize: CGSize(width: 100, height: 100),
      iconBackgroundColor: nil,
      completion: completion
    )
  }
  
  public func generateQRCode(
    from string: String,
    backgroundColor: Color,
    foregroundColor: Color,
    iconIntoQR: UIImage?,
    iconSize: CGSize,
    iconBackgroundColor: Color?,
    completion: ((UIImage?) -> Void)?
  ) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      let context = CIContext()
      let filter = CIFilter.qrCodeGenerator()
      filter.message = Data(string.utf8)
      filter.correctionLevel = "H"
      
      if let qrCodeCIImage = filter.outputImage {
        let transformedImage = qrCodeCIImage.transformed(
          by: CGAffineTransform(scaleX: 10, y: 10)
        )
        let colorParameters = [
          "inputColor0": CIColor(color: foregroundColor.uiColor),
          "inputColor1": CIColor(color: backgroundColor.uiColor)
        ]
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: colorParameters)
        colorFilter?.setValue(transformedImage, forKey: "inputImage")
        
        if let coloredImage = colorFilter?.outputImage,
           let qrCodeCGImage = context.createCGImage(coloredImage, from: coloredImage.extent) {
          let qrCodeImage = UIImage(cgImage: qrCodeCGImage)
          let icon = self?.insertIcon(
            iconIntoQR,
            in: qrCodeImage,
            iconSize: iconSize,
            iconBackgroundColor: iconBackgroundColor ?? SKStyleAsset.ghost.swiftUIColor
          )
          DispatchQueue.main.async {
            completion?(icon)
            return
          }
        }
      }
    }
  }
  
  public func saveImageToGallery(_ imageData: Data?) async -> Bool {
    await mediaSaver.saveImageToGallery(imageData)
  }
  
  public func saveVideoToGallery(_ video: URL?) async -> Bool {
    await mediaSaver.saveVideoToGallery(video)
  }
  
  public func getImage(for url: URL?, completion: @escaping (UIImage?) -> Void) {
    ImageCacheService.shared.getImage(for: url, completion: completion)
  }
  
  public func createCollectionViewSnapshot(completion: @escaping (UIImage?) -> Void) {
    // Используем DispatchGroup для отслеживания задач
    let dispatchGroup = DispatchGroup()
    var widgetImages: [UIImage] = []
    
    // Устанавливаем задержку, чтобы интроспекция сработала
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      // Начинаем отслеживание
      dispatchGroup.enter()
      
      self.performSnapshot { images in
        if let images = images {
          widgetImages.append(contentsOf: images)
        }
        // Завершаем отслеживание
        dispatchGroup.leave()
      }
      
      // Ждем завершения всех задач
      dispatchGroup.notify(queue: .main) {
        // Объединяем все снимки в одно изображение
        let finalImage = self.combineImages(images: widgetImages)
        completion(finalImage)
      }
    }
  }
}

// MARK: - UIVUIColoriew

private extension UIColor {
  static func random() -> UIColor {
    return UIColor(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      alpha: 1.0
    )
  }
}

// MARK: - UIView

// Пример метода snapshot(), который можно добавить в расширение UIView
private extension UIView {
  func snapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
    defer { UIGraphicsEndImageContext() }
    drawHierarchy(in: bounds, afterScreenUpdates: true)
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

// MARK: - Private

private extension UIService {
  func insertIcon(
    _ iconIntoQR: UIImage?,
    in qrCodeImage: UIImage,
    iconSize: CGSize,
    iconBackgroundColor: Color
  ) -> UIImage? {
    var icon = UIImage()
    var iconBackgroundColor: UIColor = iconBackgroundColor.uiColor
    
    if let iconImage = iconIntoQR {
      icon = iconImage
    } else {
      iconBackgroundColor = .clear
    }
    
    let size = qrCodeImage.size
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    
    qrCodeImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
    let iconRect = CGRect(x: (size.width - iconSize.width) / 2.0,
                          y: (size.height - iconSize.height) / 2.0,
                          width: iconSize.width,
                          height: iconSize.height)
    
    let path = UIBezierPath(ovalIn: iconRect)
    iconBackgroundColor.setFill()
    path.fill()
    icon.draw(in: iconRect)
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage
  }
  
  func randomGradientColors() -> [UIColor] {
    // Возвращаем массив из двух рандомных цветов для градиента
    return [UIColor.random(), UIColor.random()]
  }
  
  func findCollectionView(in view: UIView) -> UICollectionView? {
    if let collectionView = view as? UICollectionView {
      return collectionView
    }
    
    for subview in view.subviews {
      if let collectionView = findCollectionView(in: subview) {
        return collectionView
      }
    }
    
    return nil
  }
  
  func performSnapshot(completion: @escaping ([UIImage]?) -> Void) {
    var capturedImages: [UIImage] = []
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      completion(nil)
      return
    }
    
    // Проходим по всем окнам и их подвидам
    for window in windowScene.windows {
      for subview in window.subviews {
        if let collectionView = findCollectionView(in: subview) {
          // Сортируем ячейки по их IndexPath
          let sortedCells = collectionView.visibleCells.sorted { (cell1, cell2) -> Bool in
            guard let indexPath1 = collectionView.indexPath(for: cell1),
                  let indexPath2 = collectionView.indexPath(for: cell2) else {
              return false
            }
            if indexPath1.section == indexPath2.section {
              return indexPath1.item < indexPath2.item
            }
            return indexPath1.section < indexPath2.section
          }
          
          // Создаём снимки отсортированных ячеек
          sortedCells.forEach { cell in
            if let image = cell.contentView.snapshot() {
              capturedImages.append(image)
            }
          }
        }
      }
    }
    
    completion(capturedImages)
  }
  
  func combineImages(images: [UIImage]) -> UIImage? {
    guard !images.isEmpty else { return nil }
    
    // Настройки для итогового изображения
    let padding: CGFloat = 16
    let cornerRadius: CGFloat = 12
    let spacing: CGFloat = 16
    
    // Создаем рандомный градиент
    let gradientColors = randomGradientColors()
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientColors.map { $0.cgColor }
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    
    // Расчет итогового размера изображения с учетом отступов и расстояния между ячейками
    let totalHeight = images.reduce(0) { $0 + $1.size.height + spacing } - spacing + (padding * 2)
    let maxWidth = images.max(by: { $0.size.width < $1.size.width })?.size.width ?? 0
    let finalWidth = maxWidth + (padding * 2)
    
    // Создаем графический контекст
    UIGraphicsBeginImageContextWithOptions(CGSize(width: finalWidth, height: totalHeight), false, 0.0)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return nil
    }
    
    // Добавляем градиентный фон
    gradientLayer.frame = CGRect(x: 0, y: 0, width: finalWidth, height: totalHeight)
    gradientLayer.render(in: context)
    
    // Рисуем каждое изображение с отступами и округленными углами
    var yOffset: CGFloat = padding
    for image in images {
      let imageRect = CGRect(x: padding, y: yOffset, width: maxWidth, height: image.size.height)
      
      // Создаем путь с закругленными углами
      let path = UIBezierPath(roundedRect: imageRect, cornerRadius: cornerRadius)
      context.saveGState()
      path.addClip()
      
      // Рисуем изображение
      image.draw(in: imageRect)
      context.restoreGState()
      
      yOffset += image.size.height + spacing
    }
    
    // Получаем итоговое изображение
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return finalImage
  }
}

// MARK: - Constants

private enum Constants {
  static let colorSchemeKey = "darkModePreference"
}
