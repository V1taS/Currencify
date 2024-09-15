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
  @State private var searchViewFrame: CGRect = .zero
  
  // MARK: - Body
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      VStack {
        if presenter.isCurrencyListEmpty {
          createEmptyState()
        } else {
          createContent()
        }
      }
      
      // SearchCurrencyRateView с анимацией показа и скрытия
      if presenter.isSearchViewVisible {
        createSearchCurrencyRateView()
      }
    }
  }
}

// MARK: - Private

private extension MainScreenView {
  func createSearchCurrencyRateView() -> some View {
    VStack {
      SearchCurrencyRateView(
        placeholder: CurrencifyStrings.MainScreenLocalization.SearchCurrency.placeholder,
        currencyRates: Secrets.currencyRateList,
        availableCurrencyRate: presenter.availableCurrencyRate,
        action: { newValue in
          Task {
            await presenter.userAddCurrencyRate(newValue: newValue)
          }
        }
      )
      .background(
        GeometryReader { geometry in
          Color.clear
            .onAppear {
              self.searchViewFrame = geometry.frame(in: .global)
            }
            .onChange(of: geometry.frame(in: .global)) { newFrame in
              self.searchViewFrame = newFrame
            }
        }
      )
      .padding(.leading, .s4)
      .padding(.top, .s4)
      .transition(.move(edge: .top))
      .animation(.easeInOut, value: presenter.isSearchViewVisible)
      .onReceive(NotificationCenter.default.publisher(for: .globalTouchEvent)) { notification in
        guard let touch = notification.object as? UITouch else {
          return
        }
        let touchPoint = touch.location(in: nil)
        if !searchViewFrame.contains(touchPoint) {
          presenter.isSearchViewVisible = false
        }
      }
    }
  }
  
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
          Task {
            await presenter.refreshCurrencyData()
          }
        }
      )
    }
    .padding(.horizontal, .s4)
    .padding(.bottom, .s4)
  }
  
  func createContent() -> some View {
    List {
      ForEach(Array(presenter.currencyWidgets.enumerated()), id: \.element.id) { _, model in
        VStack(spacing: .zero) {
          WidgetCryptoView(model)
            .clipShape(RoundedRectangle(cornerRadius: .s3))
        }
        .listRowBackground(Color.clear)
        .listRowInsets(.init(top: .zero, leading: .s4, bottom: .zero, trailing: .s4))
        .listRowSeparator(.hidden)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
          Button {
            Task {
              await presenter.userRemoveCurrencyRate(currencyAlpha: model.additionalID)
            }
          } label: {
            Text(CurrencifyStrings.MainScreenLocalization.currencyDelete)
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
