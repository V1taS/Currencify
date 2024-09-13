//
//  MainScreenView.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SKStyle
import SKUIKit
import SwiftUI
import Lottie
import SKAbstractions

struct MainScreenView: View {
  
  // MARK: - Internal properties
  
  @StateObject
  var presenter: MainScreenPresenter
  
  // MARK: - Body
  
  var body: some View {
    VStack {
      if presenter.isCurrencyListEmpty {
        createEmptyState()
      } else {
        createContent()
      }
    }
  }
}

// MARK: - Private

private extension MainScreenView {
  func createEmptyState() -> some View {
    VStack {
      ScrollView(showsIndicators: false) {
        LottieView(animation: .asset(CurrencifyAsset.currencyAnimation.name))
          .resizable()
          .looping()
          .aspectRatio(contentMode: .fit)
        
        Text(CurrencifyStrings.MainScreenLocalization.Error.Load.Data.title)
          .font(.fancy.text.largeTitle)
          .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
          .multilineTextAlignment(.center)
        Text(CurrencifyStrings.MainScreenLocalization.Error.Load.Data.descriptor)
          .font(.fancy.text.largeTitle)
          .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
          .multilineTextAlignment(.center)
      }
      
      MainButtonView(
        text: CurrencifyStrings.MainScreenLocalization
          .Button.Update.title,
        action: {
          presenter.refreshCurrencyData()
        }
      )
    }
    .padding(.horizontal, .s4)
    .padding(.bottom, .s4)
  }
  
  func createContent() -> some View {
    List {
      ForEach(Array(presenter.currencyWidgets.enumerated()), id: \.element.id) { index, model in
        VStack(spacing: .zero) {
          WidgetCryptoView(model)
            .clipShape(RoundedRectangle(cornerRadius: .s3))
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: .zero, leading: .s4, bottom: .zero, trailing: .s4))
        .listRowSeparator(.hidden)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
          Button {
            // TODO: - Удалить
          } label: {
            Text("Удалить")
          }
          .tint(SKStyleAsset.constantRuby.swiftUIColor)
        }
      }
    }
    .background(Color.clear)
    .listStyle(PlainListStyle())
    .listRowSpacing(.s4)
    .listRowSeparator(.hidden)
  }
}

// MARK: - Preview

struct MainScreenView_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerPreview {
      MainScreenAssembly().createModule(
        services: ApplicationServicesStub()
      ).viewController
    }
  }
}
