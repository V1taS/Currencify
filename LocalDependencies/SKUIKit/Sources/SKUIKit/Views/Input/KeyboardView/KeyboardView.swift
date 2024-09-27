//
//  KeyboardView.swift
//
//
//  Created by Vitalii Sosin on 15.12.2023.
//

import SwiftUI
import SKStyle

public struct KeyboardView: View {
  
  // MARK: - Private properties
  
  @ObservedObject private var keyboardModel: WidgetCryptoView.KeyboardModel
  
  private var isEnabled: Bool
  private let buttonSize: CGSize = .init(width: CGFloat.s18, height: .s12)
  private let onChange: ((_ newValue: String) -> Void)?
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - isEnabled: Клавиатура включена
  ///   - keyboardModel: Модель клавиатуры
  ///   - onChange: Акшен на каждый ввод с клавиатуры
  public init(
    isEnabled: Bool,
    keyboardModel: WidgetCryptoView.KeyboardModel,
    onChange: ((_ newValue: String) -> Void)?
  ) {
    self.isEnabled = isEnabled
    self.keyboardModel = keyboardModel
    self.onChange = onChange
  }
  
  // MARK: - Body
  
  public var body: some View {
    VStack(spacing: .s1) {
      createNumberLine(numbers: Constants.firstLine)
      createNumberLine(numbers: Constants.secondLine)
      createNumberLine(numbers: Constants.thirdLine)
      createNumberLine(numbers: Constants.fourthLine)
    }
    .onChange(of: keyboardModel.value) { newValue in
      print("✅ \(newValue)")
    }
  }
}

// MARK: - Private

private extension KeyboardView {
  func createButton(title: String, action: @escaping () -> Void) -> AnyView {
    if title == "" {
      return AnyView(
        Color.clear
          .frame(width: .infinity, height: buttonSize.height)
          .clipShape(Rectangle())
          .cornerRadius(.s3)
      )
    }
    
    return AnyView(
      TapGestureView(
        style: .flash,
        isSelectable: isEnabled,
        touchesEnded: {
          if [",", "."].contains(title) {
            if !(keyboardModel.value.contains(",") || keyboardModel.value.contains(".")) {
              action()
            }
          } else {
            action()
          }
        }
      ) {
        ZStack {
          SKStyleAsset.constantSlate.swiftUIColor.opacity(0.05)
          
          Text(title)
            .font(.fancy.text.largeTitle)
            .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
        }
        .frame(width: .infinity, height: buttonSize.height)
        .clipShape(Rectangle())
        .cornerRadius(.s3)
      }
    )
  }
  
  func createNumberLine(numbers: [String]) -> AnyView {
    AnyView(
      HStack(spacing: .s1) {
        ForEach(Array(numbers.enumerated()), id: \.offset) { _, number in
          switch number {
          case Constants.spacer:
            Spacer()
          case Constants.remove:
            createRemoveButton {
              if !keyboardModel.value.isEmpty {
                keyboardModel.value.removeLast()
                onChange?(keyboardModel.value)
              }
            }
          default:
            createButton(title: number) {
              keyboardModel.value.append(number)
              onChange?(keyboardModel.value)
            }
            .disabled(keyboardModel.keyboardIsBlock)
          }
        }
      }
    )
  }
  
  func createRemoveButton(action: @escaping () -> Void) -> AnyView {
    AnyView(
      TapGestureView(
        style: .flash,
        isSelectable: isEnabled,
        touchesEnded: action
      ) {
        ZStack {
          SKStyleAsset.constantSlate.swiftUIColor.opacity(0.05)
          
          Image(systemName: "delete.backward")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: .s7)
            .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
        }
        .frame(width: .infinity, height: buttonSize.height)
        .clipShape(Rectangle())
        .cornerRadius(.s3)
      }
    )
  }
}


// MARK: - Constants

private enum Constants {
  static let spacer = "Spacer"
  static let remove = "Remove"
  static let firstLine: [String] = [
    "1",
    "2",
    "3"
  ]
  static let secondLine: [String] = [
    "4",
    "5",
    "6"
  ]
  static let thirdLine: [String] = [
    "7",
    "8",
    "9"
  ]
  static let fourthLine: [String] = [
    ",",
    "0",
    Constants.remove
  ]
}

// MARK: - Preview

struct KeyboardView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      VStack {
        Spacer()
        
        HStack {
          KeyboardView(
            isEnabled: true,
            keyboardModel: .init(),
            onChange: { newValue in }
          )
        }
      }
      .padding(.bottom, .s20)
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
  
  func triggerHapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }
}
