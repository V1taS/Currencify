//
//  WidgetCryptoView+Model.swift
//
//
//  Created by Vitalii Sosin on 13.12.2023.
//

import SwiftUI
import SKStyle

// MARK: - Model

@available(iOS 16.0, *)
extension WidgetCryptoView {
  public class Model: ObservableObject, Identifiable, Hashable {
    
    // MARK: - Public properties
    
    @Published public var id: String
    @Published public var additionalID: String
    @Published public var leftSide: ContentModel?
    @Published public var rightSide: ContentModel?
    @Published public var rightSideLargeTextModel: TextModel?
    @Published public var additionCenterTextModel: TextModel?
    @Published public var additionCenterContent: AnyView?
    @Published public var keyboardModel: KeyboardModel?
    @Published public var isSelectable: Bool
    @Published public var backgroundColor: Color?
    @Published public var action: (() -> Void)?
    @Published public var horizontalSpacing: CGFloat
    @Published public var leadingPadding: CGFloat
    @Published public var trailingPadding: CGFloat
    @Published public var verticalPadding: CGFloat
    
    // MARK: - Initialization
    
    /// Инициализатор для создания модельки для виджета
    /// - Parameters:
    ///   - additionalID: Дополнительный идентификатор
    ///   - leftSide: Левая сторона виджета
    ///   - rightSide: Правая сторона виджета
    ///   - rightSideLargeTextModel: Большой текст справой стороны
    ///   - additionCenterTextModel: Дополнительный текст по центру
    ///   - additionCenterContent: Дополнительный контент по центру
    ///   - keyboardModel: Клавиатура
    ///   - isSelectable: Можно ли нажать на ячейку
    ///   - backgroundColor: Цвет фона виджета
    ///   - horizontalSpacing: Горизонтальный внутренний отступ
    ///   - leadingPadding: Левый внешний отступ
    ///   - trailingPadding: Правый внешний отступ
    ///   - verticalPadding: Вертикальный внешний отступ
    ///   - action: Замыкание, которое будет выполняться при нажатии на виджет
    public init(
      additionalID: String = UUID().uuidString,
      leftSide: ContentModel? = nil,
      rightSide: ContentModel? = nil,
      rightSideLargeTextModel: TextModel? = nil,
      additionCenterTextModel: TextModel? = nil,
      additionCenterContent: AnyView? = nil,
      keyboardModel: KeyboardModel? = nil,
      isSelectable: Bool = true,
      backgroundColor: Color? = nil,
      horizontalSpacing: CGFloat = .s4,
      leadingPadding: CGFloat = .s4,
      trailingPadding: CGFloat = .s4,
      verticalPadding: CGFloat = .s3,
      action: (() -> Void)? = nil
    ) {
      self.id = UUID().uuidString
      self.additionalID = additionalID
      self.leftSide = leftSide
      self.rightSide = rightSide
      self.rightSideLargeTextModel = rightSideLargeTextModel
      self.additionCenterTextModel = additionCenterTextModel
      self.additionCenterContent = additionCenterContent
      self.keyboardModel = keyboardModel
      self.isSelectable = isSelectable
      self.backgroundColor = backgroundColor
      self.horizontalSpacing = horizontalSpacing
      self.leadingPadding = leadingPadding
      self.trailingPadding = trailingPadding
      self.verticalPadding = verticalPadding
      self.action = action
    }
  }
}

// MARK: - LeftSide

@available(iOS 16.0, *)
extension WidgetCryptoView {
  public class ContentModel: ObservableObject, Equatable, Hashable {
    // MARK: - Public properties
    @Published public var imageModel: ImageModel?
    @Published public var itemModel: ItemModel?
    @Published public var titleModel: TextModel?
    @Published public var titleAdditionModel: TextModel?
    @Published public var titleAdditionRoundedModel: TextModel?
    @Published public var descriptionModel: TextModel?
    @Published public var descriptionAdditionModel: TextModel?
    @Published public var descriptionAdditionRoundedModel: TextModel?
    
    // MARK: - Initialization
    
    /// Инициализатор для создания модельки для виджета
    /// - Parameters:
    ///   - imageModel: Иконка
    ///   - itemModel: Любой AnyView
    ///   - titleModel: Заголовок
    ///   - titleAdditionModel: Дополнительный заголовок
    ///   - titleAdditionRoundedModel: Дополнительный заголовок скругленного текста
    ///   - descriptionModel: Описание
    ///   - descriptionAdditionModel: Дополнительное описание
    ///   - descriptionAdditionRoundedModel: Дополнительное описание скругленного текста
    public init(
      imageModel: ImageModel? = nil,
      itemModel: ItemModel? = nil,
      titleModel: TextModel? = nil,
      titleAdditionModel: TextModel? = nil,
      titleAdditionRoundedModel: TextModel? = nil,
      descriptionModel: TextModel? = nil,
      descriptionAdditionModel: TextModel? = nil,
      descriptionAdditionRoundedModel: TextModel? = nil
    ) {
      self.imageModel = imageModel
      self.itemModel = itemModel
      self.titleModel = titleModel
      self.titleAdditionModel = titleAdditionModel
      self.titleAdditionRoundedModel = titleAdditionRoundedModel
      self.descriptionModel = descriptionModel
      self.descriptionAdditionModel = descriptionAdditionModel
      self.descriptionAdditionRoundedModel = descriptionAdditionRoundedModel
    }
    
    // Реализация Equatable и Hashable
    public static func == (lhs: ContentModel, rhs: ContentModel) -> Bool {
      return lhs.imageModel == rhs.imageModel &&
      lhs.itemModel == rhs.itemModel &&
      lhs.titleModel == rhs.titleModel &&
      lhs.titleAdditionModel == rhs.titleAdditionModel &&
      lhs.titleAdditionRoundedModel == rhs.titleAdditionRoundedModel &&
      lhs.descriptionModel == rhs.descriptionModel &&
      lhs.descriptionAdditionModel == rhs.descriptionAdditionModel &&
      lhs.descriptionAdditionRoundedModel == rhs.descriptionAdditionRoundedModel
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(imageModel)
      hasher.combine(itemModel)
      hasher.combine(titleModel)
      hasher.combine(titleAdditionModel)
      hasher.combine(titleAdditionRoundedModel)
      hasher.combine(descriptionModel)
      hasher.combine(descriptionAdditionModel)
      hasher.combine(descriptionAdditionRoundedModel)
    }
  }
}

// MARK: - KeyboardModel

@available(iOS 16.0, *)
extension WidgetCryptoView {
  public class KeyboardModel: ObservableObject {
    @Published public var value: String
    @Published public var isKeyboardShown: Bool
    @Published public var keyboardIsBlock: Bool
    @Published public var onChange: ((_ newValue: String) -> Void)?
    
    // MARK: - Initialization
    
    /// Инициализатор
    /// - Parameters:
    ///   - value: Пин код
    ///   - isKeyboardShown: Клавиатура показана
    ///   - keyboardIsBlock: Установить блокировку клавишь
    ///   - onChange: Акшен на каждый ввод с клавиатуры
    public init(
      value: String = "",
      isKeyboardShown: Bool = false,
      keyboardIsBlock: Bool = false,
      onChange: ((_ newValue: String) -> Void)? = nil
    ) {
      self.value = value
      self.isKeyboardShown = isKeyboardShown
      self.keyboardIsBlock = keyboardIsBlock
      self.onChange = onChange
    }
  }
}

// MARK: - TextModel

@available(iOS 16.0, *)
extension WidgetCryptoView {
  public class TextModel: ObservableObject, Equatable, Hashable {
    // MARK: - Public properties
    @Published public var text: String
    @Published public var textFont: Font
    @Published public var lineLimit: Int
    @Published public var textStyle: TextStyle
    @Published public var textIsSecure: Bool
    
    // MARK: - Initialization
    
    /// Инициализатор для создания модельки
    /// - Parameters:
    ///   - text: Заголовок
    ///   - textFont: Шрифт текста
    ///   - lineLimit: Количество строк
    ///   - textStyle: Стиль заголовка
    ///   - textIsSecure: Заголовок скрыт
    public init(
      text: String,
      textFont: Font = .fancy.text.regular,
      lineLimit: Int = 1,
      textStyle: TextStyle = .standart,
      textIsSecure: Bool = false
    ) {
      self.text = text
      self.textFont = textFont
      self.lineLimit = lineLimit
      self.textStyle = textStyle
      self.textIsSecure = textIsSecure
    }
    
    // Реализация Equatable и Hashable
    public static func == (lhs: TextModel, rhs: TextModel) -> Bool {
      return lhs.text == rhs.text &&
      lhs.textFont == rhs.textFont &&
      lhs.lineLimit == rhs.lineLimit &&
      lhs.textStyle == rhs.textStyle &&
      lhs.textIsSecure == rhs.textIsSecure
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(text)
      hasher.combine(textFont)
      hasher.combine(lineLimit)
      hasher.combine(textStyle)
      hasher.combine(textIsSecure)
    }
  }
}

// MARK: - TextStyle

@available(iOS 16.0, *)
extension WidgetCryptoView {
  /// Стиль текста в виджете
  public enum TextStyle: Equatable, Hashable {
    /// Цвет из стиля
    var color: Color {
      switch self {
      case .standart:
        return SKStyleAsset.ghost.swiftUIColor
      case .positive:
        return SKStyleAsset.constantLime.swiftUIColor
      case .negative:
        return SKStyleAsset.constantRuby.swiftUIColor
      case .attention:
        return SKStyleAsset.constantAmberGlow.swiftUIColor
      case .netural:
        return SKStyleAsset.constantSlate.swiftUIColor
      }
    }
    
    /// Стандартный белый цвет
    case standart
    /// Позитивный зеленый цвет
    case positive
    /// Негативный красный цвет
    case negative
    /// Внимание оранжевый цвет
    case attention
    /// Нетральный серый цвет
    case netural
  }
}

// MARK: - ItemModel

@available(iOS 16.0, *)
extension WidgetCryptoView {
  public enum ItemModel: Equatable, Hashable {
    // Реализация Equatable
    public static func == (lhs: WidgetCryptoView.ItemModel, rhs: WidgetCryptoView.ItemModel) -> Bool {
      return lhs.size == rhs.size
    }
    
    var size: CGSize {
      switch self {
      case let .custom(_, size, _):
        switch size {
        case .standart:
          return .init(width: CGFloat.s4, height: .s4)
        case .large:
          return .init(width: CGFloat.s11, height: .s11)
        case let .custom(width, height):
          return .init(width: width ?? .infinity, height: height ?? .infinity)
        }
      case .switcher:
        return .init(width: .infinity, height: CGFloat.s4)
      case .radioButtons:
        return .init(width: CGFloat.s4, height: .s4)
      case .checkMarkButton:
        return .init(width: CGFloat.s4, height: .s4)
      case .infoButton:
        return .init(width: CGFloat.s6, height: .s6)
      }
    }
    
    /// Пользовательские настройки
    case custom(item: AnyView, size: Size = .large, isHitTesting: Bool = false)
    /// Переключатель
    case switcher(initNewValue: Bool = false, isEnabled: Bool = true, action: ((_ newValue: Bool) -> Void)?)
    /// Круглая кнопка
    case radioButtons(initNewValue: Bool = false, isChangeValue: Bool = true, action: ((_ newValue: Bool) -> Void)?)
    /// Кнопка выбора
    case checkMarkButton(initNewValue: Bool = false, isChangeValue: Bool = true, action: ((_ newValue: Bool) -> Void)?)
    /// Кнопка для получения дополнительной информации
    case infoButton(action: (() -> Void)?)
    
    public enum Size: Equatable {
      case standart
      case large
      case custom(width: CGFloat? = nil, height: CGFloat? = nil)
    }
  }
}

// MARK: - ImageModel

@available(iOS 16.0, *)
extension WidgetCryptoView {
  public enum ImageModel: Equatable, Hashable {
    var roundedStyle: WidgetCryptoView.ImageModel.RoundedStyle {
      switch self {
      case let .custom(_, _, _, _, _, roundedStyle):
        return roundedStyle
      case .chevron:
        return .circle
      }
    }
    
    var size: CGSize {
      switch self {
      case let .custom(_, _, _, _, size, _):
        switch size {
        case .standart:
          return .init(width: CGFloat.s4, height: .s4)
        case .large:
          return .init(width: CGFloat.s11, height: .s11)
        }
      case .chevron:
        return .init(width: CGFloat.s3, height: .s3)
      }
    }
    
    var backgroundColor: Color? {
      switch self {
      case let .custom(_, _, _, backgroundColor, _, _):
        return backgroundColor
      case .chevron:
        return nil
      }
    }
    
    var imageColor: Color? {
      switch self {
      case let .custom(_, _, color, _, _, _):
        return color ?? SKStyleAsset.ghost.swiftUIColor
      case .chevron:
        return SKStyleAsset.constantSlate.swiftUIColor
      }
    }
    
    var image: Image? {
      switch self {
      case let .custom(image, _, _, _, _, _):
        return image
      case .chevron:
        return Image(systemName: "chevron.right")
      }
    }
    
    var imageURL: URL? {
      switch self {
      case let .custom(_, imageURL, _, _, _, _):
        return imageURL
      default:
        return nil
      }
    }
    
    /// Пользовательские настройки
    case custom(
      image: Image? = nil,
      imageURL: URL? = nil,
      color: Color? = nil,
      backgroundColor: Color? = nil,
      size: Size = .large,
      roundedStyle: RoundedStyle = .circle
    )
    
    /// Шеврон (стрелочка вправо)
    case chevron
    
    public enum RoundedStyle: Equatable, Hashable {
      case circle
      case squircle
    }
    
    public enum Size: Equatable, Hashable {
      case standart
      case large
    }
  }
}

// MARK: - Equatable

@available(iOS 16.0, *)
extension WidgetCryptoView.Model: Equatable {
  public static func == (lhs: WidgetCryptoView.Model, rhs: WidgetCryptoView.Model) -> Bool {
    return lhs.id == rhs.id &&
    lhs.leftSide == rhs.leftSide &&
    lhs.rightSide == rhs.rightSide &&
    lhs.additionCenterTextModel == rhs.additionCenterTextModel &&
    lhs.isSelectable == rhs.isSelectable &&
    lhs.backgroundColor == rhs.backgroundColor
  }
}

// MARK: - Hashable Model

@available(iOS 16.0, *)
extension WidgetCryptoView.Model {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(leftSide)
    hasher.combine(rightSide)
    hasher.combine(additionCenterTextModel)
    hasher.combine(isSelectable)
    hasher.combine(backgroundColor)
  }
}

// MARK: - Hashable ItemModel

@available(iOS 16.0, *)
extension WidgetCryptoView.ItemModel {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .custom(_, _, let isHitTesting):
      hasher.combine("custom")
      hasher.combine(isHitTesting)
      
    case let .switcher(initNewValue, _, _):
      hasher.combine("switcher")
      hasher.combine(initNewValue)
      
    case let .radioButtons(initNewValue, _, _):
      hasher.combine("radioButtons")
      hasher.combine(initNewValue)
      
    case let .checkMarkButton(initNewValue, _, _):
      hasher.combine("checkMarkButton")
      hasher.combine(initNewValue)
      
    case .infoButton(_):
      hasher.combine("infoButton")
    }
  }
}

// MARK: - Hashable ImageModel

@available(iOS 16.0, *)
extension WidgetCryptoView.ImageModel {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case let .custom(_, _, color, backgroundColor, size, roundedStyle):
      hasher.combine("custom")
      hasher.combine(color)
      hasher.combine(backgroundColor)
      hasher.combine(size)
      hasher.combine(roundedStyle)
      
    case .chevron:
      hasher.combine("chevron")
    }
  }
}

// MARK: - Equatable and Hashable Conformance

@available(iOS 16.0, *)
extension WidgetCryptoView.KeyboardModel: Equatable, Hashable {
  public static func == (lhs: WidgetCryptoView.KeyboardModel,
                         rhs: WidgetCryptoView.KeyboardModel) -> Bool {
    return lhs.value == rhs.value &&
    lhs.isKeyboardShown == rhs.isKeyboardShown &&
    lhs.keyboardIsBlock == rhs.keyboardIsBlock
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(value)
    hasher.combine(isKeyboardShown)
    hasher.combine(keyboardIsBlock)
  }
}
