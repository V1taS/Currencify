//
//  CompactSliderView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 14.09.2024.
//

import SwiftUI
import CompactSlider
import SKStyle

public struct CompactSliderView: View {
  
  // MARK: - Private properties
  
  @State private var value: Double = 0.0
  @State private var timer: Timer?
  @State private var isEnabled: Bool = true
  private let action: ((_ newValue: Double) -> Void)?
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - value: Значение по умолчанию
  ///   - isEnabled: Слайдер включен
  ///   - action: Действие по перемещению слайдера
  public init(
    value: Double = .zero,
    isEnabled: Bool = true,
    action: ((_ newValue: Double) -> Void)?
  ) {
    self.value = value
    self.isEnabled = isEnabled
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      CompactSlider(
        value: $value,
        in: -20...20,
        step: 0.5,
        direction: .center,
        handleVisibility: .standard,
        scaleVisibility: .hovering,
        minHeight: .s10,
        enableDragGestureDelayForiOS: false
      ) {
        if value <= .zero {
          Text(String(format: "- %.1f %%", abs(value)))
            .font(.fancy.text.regular)
            .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
            .lineLimit(1)
        }
        
        Spacer()
        
        if value >= .zero {
          Text(String(format: "+ %.1f %%", value))
            .font(.fancy.text.regular)
            .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
            .lineLimit(1)
        }
      }
      .compactSliderStyle(
        .prominent(
          lowerColor: .red,
          upperColor: .green,
          useGradientBackground: false
        )
      )
      .disabled(!isEnabled)
    }
    .onChange(of: value) { newValue in
      timer?.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        action?(newValue)
      }
    }
  }
}

// MARK: - Preview

struct CompactSliderView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      VStack {
        HStack {
          Spacer()
          CompactSliderView(
            value: .zero,
            isEnabled: true,
            action: { _ in }
          )
          Spacer()
        }
      }
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
