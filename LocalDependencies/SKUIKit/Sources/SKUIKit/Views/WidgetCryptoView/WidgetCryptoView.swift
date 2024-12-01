//
//  WidgetCryptoView.swift
//
//
//  Created by Vitalii Sosin on 03.12.2023.
//

import SwiftUI
import SKStyle

@available(iOS 16.0, *)
public struct WidgetCryptoView: View {
  
  // MARK: - Private properties
  
  @ObservedObject private var model: WidgetCryptoView.Model
  
  // MARK: - Initialization
  
  /// Инициализатор для создания виджета с криптовалютой
  /// - Parameters:
  ///   - model: Модель данных
  public init(_ model: WidgetCryptoView.Model) {
    self.model = model
  }
  
  // MARK: - Body
  
  public var body: some View {
    createWidgetCrypto(model: model)
  }
}

// MARK: - Private

@available(iOS 16.0, *)
private extension WidgetCryptoView {
  func createWidgetCrypto(model: WidgetCryptoView.Model) -> AnyView {
    AnyView(
      VStack {
        ZStack {
          TapGestureView(
            style: .flash,
            isSelectable: model.isSelectable,
            touchesEnded: {
              DispatchQueue.main.async {
                model.action?()
              }
            }
          ) {
            model.backgroundColor ?? SKStyleAsset.navy.swiftUIColor
          }
          
          VStack(spacing: .zero) {
            HStack(alignment: .center, spacing: model.horizontalSpacing) {
              createLeftSideImage(model: model)
              createLeftSideItem(model: model)
              
              VStack(spacing: .s1) {
                createFirstLineContent(model: model)
                createSecondLineContent(model: model)
              }
              // TODO: - Костыль что бы значение валюты растягивалось на весь экран
              .if(
                model.rightSide?.imageModel == nil && model.rightSide?.itemModel == nil,
                transform: { view in
                  view
                    .fixedSize(horizontal: true, vertical: false)
                },
                else: { view in
                  view
                }
              )
              
              if model.leftSide != nil && model.rightSide == nil {
                Spacer(minLength: .zero)
              }
              
              createRightSideImage(model: model)
              createRightSideItem(model: model)
              createRightLargeText(model: model)
            }
            
            if let additionContent = model.additionCenterContent {
              additionContent
            }
            
            if let additionTextModel = model.additionCenterTextModel {
              Text(additionTextModel.textIsSecure ? Constants.secureText : additionTextModel.text)
                .font(.fancy.text.regular)
                .foregroundColor(additionTextModel.textStyle.color)
                .multilineTextAlignment(.center)
                .lineLimit(.max)
                .roundedEdge(backgroundColor: additionTextModel.textStyle.color.opacity(0.07))
                .padding(.top, .s4)
                .allowsHitTesting(false)
            }
          }
          .padding(.leading, model.leadingPadding)
          .padding(.trailing, model.trailingPadding)
          .padding(.vertical, model.verticalPadding)
        }
        
        createKeyboardModel(model)
          .background(SKStyleAsset.navy.swiftUIColor)
      }
    )
  }
  
  func createLeftSideImage(model: WidgetCryptoView.Model) -> AnyView {
    AnyView(
      Group {
        if let imageModel = model.leftSide?.imageModel {
          let shape: some Shape = imageModel.roundedStyle == .circle ?
          AnyShape(Circle()) :
          AnyShape(RoundedRectangle(cornerRadius: .s3))
          
          if let image = imageModel.image {
            image
              .resizable()
              .frame(width: imageModel.size.width, height: imageModel.size.height)
              .aspectRatio(contentMode: .fit)
              .if(imageModel.imageColor?.foregroundColor != nil, transform: { view in
                view.foregroundColor(imageModel.imageColor ?? SKStyleAsset.constantAzure.swiftUIColor)
              })
              .if(imageModel.backgroundColor != nil, transform: { view in
                view.background(imageModel.backgroundColor ?? .clear)
              })
              .clipShape(shape)
              .allowsHitTesting(false)
          }
          
          if let imageURL = imageModel.imageURL {
            AsyncNetworkImageView(
              .init(
                imageUrl: imageURL,
                size: .init(width: imageModel.size.width, height: imageModel.size.height),
                cornerRadiusType: imageModel.roundedStyle == .circle ? .circle : .squircle
              )
            )
          }
        }
      }
    )
  }
  
  func createRightSideImage(model: WidgetCryptoView.Model) -> AnyView {
    AnyView(
      Group {
        if let imageModel = model.rightSide?.imageModel {
          let shape: some Shape = imageModel.roundedStyle == .circle ?
          AnyShape(Circle()) :
          AnyShape(RoundedRectangle(cornerRadius: .s3))
          
          if let image = imageModel.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: imageModel.size.width, height: imageModel.size.height)
              .if(imageModel.imageColor?.foregroundColor != nil, transform: { view in
                view.foregroundColor(imageModel.imageColor ?? SKStyleAsset.constantAzure.swiftUIColor)
              })
              .if(imageModel.backgroundColor != nil, transform: { view in
                view.background(imageModel.backgroundColor ?? .clear)
              })
              .clipShape(shape)
              .allowsHitTesting(false)
          }
          
          if let imageURL = imageModel.imageURL {
            AsyncNetworkImageView(
              .init(
                imageUrl: imageURL,
                size: .init(width: imageModel.size.width, height: imageModel.size.height),
                cornerRadiusType: imageModel.roundedStyle == .circle ? .circle : .squircle
              )
            )
          }
        }
      }
    )
  }
  
  func createRightSideItem(model: WidgetCryptoView.Model) -> AnyView {
    if let itemModel = model.rightSide?.itemModel {
      return createItem(itemModel: itemModel)
    }
    return AnyView(EmptyView())
  }
  
  func createKeyboardModel(_ model: WidgetCryptoView.Model) -> some View {
    Group {
      if let keyboardModel = model.keyboardModel, keyboardModel.isKeyboardShown {
        VStack {
          Spacer()
            .background(SKStyleAsset.navy.swiftUIColor)
            .frame(height: .s4)
          
          KeyboardView(
            isEnabled: true,
            keyboardModel: keyboardModel,
            onChange: keyboardModel.onChange
          )
        }
        .padding(.horizontal, .s1)
        .padding(.bottom, .s1)
      }
    }
  }
  
  func createRightLargeText(model: WidgetCryptoView.Model) -> AnyView {
    if let rightSideLargeText = model.rightSideLargeTextModel {
      return AnyView(
        HStack(spacing: .zero) {
          Spacer(minLength: .zero)
          Text(rightSideLargeText.text.isEmpty ? "0" : rightSideLargeText.text)
            .foregroundColor(rightSideLargeText.textStyle.color)
            .lineLimit(rightSideLargeText.lineLimit)
            .font(.fancy.constant.h2)
            .foregroundColor(rightSideLargeText.textStyle.color)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }
          .allowsHitTesting(false)
      )
    }
    return AnyView(EmptyView())
  }
  
  func createLeftSideItem(model: WidgetCryptoView.Model) -> AnyView {
    if let itemModel = model.leftSide?.itemModel {
      return createItem(itemModel: itemModel)
    }
    return AnyView(EmptyView())
  }
  
  func createFirstLineContent(model: WidgetCryptoView.Model) -> AnyView {
    AnyView(
      HStack(alignment: .center, spacing: .s2) {
        if let titleModel = model.leftSide?.titleModel {
          Text(titleModel.textIsSecure ? Constants.secureText : titleModel.text)
            .font(titleModel.textFont)
            .foregroundColor(titleModel.textStyle.color)
            .multilineTextAlignment(.leading)
            .lineLimit(titleModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleAdditionModel = model.leftSide?.titleAdditionModel {
          Text(titleAdditionModel.text)
            .font(titleAdditionModel.textFont)
            .foregroundColor(titleAdditionModel.textStyle.color)
            .multilineTextAlignment(.leading)
            .lineLimit(titleAdditionModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleAdditionRoundedModel = model.leftSide?.titleAdditionRoundedModel {
          Text(titleAdditionRoundedModel.text)
            .font(titleAdditionRoundedModel.textFont)
            .foregroundColor(titleAdditionRoundedModel.textStyle.color)
            .multilineTextAlignment(.leading)
            .lineLimit(titleAdditionRoundedModel.lineLimit)
            .truncationMode(.middle)
            .roundedEdge(backgroundColor: titleAdditionRoundedModel.textStyle.color.opacity(0.07))
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        Spacer(minLength: .zero)
        
        if let titleAdditionRoundedModel = model.rightSide?.titleAdditionRoundedModel {
          Text(titleAdditionRoundedModel.text)
            .font(titleAdditionRoundedModel.textFont)
            .foregroundColor(titleAdditionRoundedModel.textStyle.color)
            .multilineTextAlignment(.trailing)
            .lineLimit(titleAdditionRoundedModel.lineLimit)
            .truncationMode(.middle)
            .roundedEdge(backgroundColor: titleAdditionRoundedModel.textStyle.color.opacity(0.07))
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleAdditionModel = model.rightSide?.titleAdditionModel {
          Text(titleAdditionModel.text)
            .font(titleAdditionModel.textFont)
            .foregroundColor(titleAdditionModel.textStyle.color)
            .multilineTextAlignment(.trailing)
            .lineLimit(titleAdditionModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleModel = model.rightSide?.titleModel {
          Text(titleModel.textIsSecure ? Constants.secureText : titleModel.text)
            .font(titleModel.textFont)
            .foregroundColor(titleModel.textStyle.color)
            .multilineTextAlignment(.trailing)
            .lineLimit(titleModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
      }
    )
  }
  
  func createSecondLineContent(model: WidgetCryptoView.Model) -> AnyView {
    AnyView(
      HStack(alignment: .center, spacing: .s2) {
        if let titleModel = model.leftSide?.descriptionModel {
          Text(titleModel.textIsSecure ? Constants.secureText : titleModel.text)
            .font(titleModel.textFont)
            .foregroundColor(titleModel.textStyle.color)
            .multilineTextAlignment(.leading)
            .lineLimit(titleModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleAdditionModel = model.leftSide?.descriptionAdditionModel {
          Text(titleAdditionModel.text)
            .font(titleAdditionModel.textFont)
            .foregroundColor(titleAdditionModel.textStyle.color)
            .multilineTextAlignment(.leading)
            .lineLimit(titleAdditionModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleAdditionRoundedModel = model.leftSide?.descriptionAdditionRoundedModel {
          Text(titleAdditionRoundedModel.text)
            .font(titleAdditionRoundedModel.textFont)
            .foregroundColor(titleAdditionRoundedModel.textStyle.color)
            .multilineTextAlignment(.leading)
            .lineLimit(titleAdditionRoundedModel.lineLimit)
            .truncationMode(.middle)
            .roundedEdge(backgroundColor: titleAdditionRoundedModel.textStyle.color.opacity(0.07))
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        Spacer(minLength: .zero)
        
        if let titleAdditionRoundedModel = model.rightSide?.descriptionAdditionRoundedModel {
          Text(titleAdditionRoundedModel.text)
            .font(titleAdditionRoundedModel.textFont)
            .foregroundColor(titleAdditionRoundedModel.textStyle.color)
            .multilineTextAlignment(.trailing)
            .lineLimit(titleAdditionRoundedModel.lineLimit)
            .truncationMode(.middle)
            .roundedEdge(backgroundColor: titleAdditionRoundedModel.textStyle.color.opacity(0.07))
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleAdditionModel = model.rightSide?.descriptionAdditionModel {
          Text(titleAdditionModel.text)
            .font(titleAdditionModel.textFont)
            .foregroundColor(titleAdditionModel.textStyle.color)
            .multilineTextAlignment(.trailing)
            .lineLimit(titleAdditionModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
        
        if let titleModel = model.rightSide?.descriptionModel {
          Text(titleModel.textIsSecure ? Constants.secureText : titleModel.text)
            .font(titleModel.textFont)
            .foregroundColor(titleModel.textStyle.color)
            .multilineTextAlignment(.trailing)
            .lineLimit(titleModel.lineLimit)
            .truncationMode(.middle)
            .allowsHitTesting(false)
            .fixedSize(horizontal: true, vertical: false)
        }
      }
    )
  }
  
  func createItem(itemModel: WidgetCryptoView.ItemModel) -> AnyView {
    switch itemModel {
    case let .custom(item, _, isHitTesting):
      return AnyView(
        item
          .frame(width: itemModel.size.width, height: itemModel.size.height)
          .allowsHitTesting(isHitTesting)
          .layoutPriority(2)
      )
    case let .switcher(initNewValue, isEnabled, action):
      return AnyView(
        SwitcherView(isOn: initNewValue, isEnabled: isEnabled, action: action)
          .allowsHitTesting(true)
          .frame(width: 60, alignment: .trailing)
          .padding(.leading, .s2)
      )
    case let .radioButtons(initNewValue, isChangeValue, action):
      return AnyView(
        CheckmarkView(
          text: nil,
          toggleValue: initNewValue,
          isChangeValue: isChangeValue,
          style: .circle,
          action: action
        )
        .allowsHitTesting(true)
        .layoutPriority(3)
      )
    case let .checkMarkButton(initNewValue, isChangeValue, action):
      return AnyView(
        CheckmarkView(
          text: nil,
          toggleValue: initNewValue,
          isChangeValue: isChangeValue,
          action: action
        )
        .allowsHitTesting(true)
      )
    case let .infoButton(action):
      return AnyView(
        Button(action: {
          action?()
        }, label: {
          Image(systemName: "info.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: itemModel.size.width, height: itemModel.size.height)
            .foregroundColor(SKStyleAsset.constantAzure.swiftUIColor)
        })
      )
    }
  }
}

// MARK: - Constants

private enum Constants {
  static let secureText = "* * *"
  static let mockImageData = Image(systemName: "link.circle")
}

// MARK: - Preview

@available(iOS 16.0, *)
struct WidgetCryptoView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Spacer()
      WidgetCryptoView(
        .init(
          leftSide: .init(
            titleModel: .init(
              text: "ETH",
              textStyle: .standart
            )
          ),
          rightSide: .init(
            itemModel: .radioButtons(
              initNewValue: true,
              action: {_ in}
            )
          ),
          additionCenterTextModel: nil,
          additionCenterContent: nil,
          isSelectable: false,
          backgroundColor: nil,
          action: {}
        )
      )
      Spacer()
    }
    .padding(.top, .s26)
    .padding(.horizontal)
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
