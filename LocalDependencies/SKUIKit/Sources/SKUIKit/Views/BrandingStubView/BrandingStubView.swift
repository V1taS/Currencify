//
//  BrandingStubView.swift
//  SKUIKit
//
//  Created by Vladimir Stepanchikov on 7/22/24.
//

import SwiftUI
import SKStyle
import SKFoundation

/// Представление-заглушка, например, используется для отображения, когда пользователь делает скришот экрана.
public struct BrandingStubView: View {
  
  // MARK: - Private properties
  private let text: String?
  
  // MARK: - Initialization
  /// Инициализатор
  /// - Parameters:
  ///   - text: Описание, отображаемое на экране
  public init(text: String? = nil) {
    self.text = text
  }
  
  // MARK: - Body
  public var body: some View {
    ZStack {
      SKStyleAsset.onyx.swiftUIColor
      VStack(spacing: .s4) {
        Spacer()
        
        Image(SKStyleAsset.currencifyLogo.name, bundle: Bundle.module)
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
          .frame(width: .gridValue(forSteps: .s9))
        
        if let text {
          Text(text)
            .font(.fancy.text.largeTitle)
            .foregroundStyle(SKStyleAsset.ghost.swiftUIColor)
            .multilineTextAlignment(.center)
        }
        
        Spacer()
        Spacer()
      }
      .padding(.s4)
    }
    .ignoresSafeArea()
  }
}

// MARK: - Preview
#if DEBUG
#Preview {
  BrandingStubView(text: "Taking a screenshot is not available")
}
#endif
