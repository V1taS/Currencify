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
  
  // MARK: - Private properties
  
  @State private var searchViewFrame: CGRect = .zero
  @State private var widgetFrames: [String: CGRect] = [:]
  @State private var navigationBarFrame: CGRect = .zero
  
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
    .environment(\.editMode, $presenter.isEditMode)
    .background(
      GeometryReader { geometry in
        Color.clear
          .onAppear {
            // Захват фрейма навигационной панели
            let navBarHeight = geometry.size.height
            let window = UIApplication.currentWindow
            let safeAreaTop = window?.safeAreaInsets.top ?? 0
            navigationBarFrame = CGRect(x: 0, y: 0, width: geometry.size.width, height: navBarHeight + safeAreaTop)
          }
          .onChange(of: geometry.frame(in: .global)) { newFrame in
            let navBarHeight = newFrame.size.height
            let window = UIApplication.currentWindow
            let safeAreaTop = window?.safeAreaInsets.top ?? 0
            navigationBarFrame = CGRect(x: 0, y: 0, width: newFrame.size.width, height: navBarHeight + safeAreaTop)
          }
      }
    )
    .onReceive(NotificationCenter.default.publisher(for: .globalTouchEvent)) { notification in
      guard let touch = notification.object as? UITouch else {
        return
      }
      let touchPoint = touch.location(in: nil)
      
      // Проверка, находится ли касание вне области поиска
      if !searchViewFrame.contains(touchPoint) {
        presenter.isSearchViewVisible = false
      }
      
      // Проверка, находится ли касание внутри любого из WidgetCryptoView
      let isTouchInsideAnyWidget = widgetFrames.values.contains { $0.contains(touchPoint) }
      
      // Дополнительная проверка для навигационной панели
      let isTouchInsideNavigationBar = navigationBarFrame.contains(touchPoint)
      
      // Если касание вне всех виджетов, вызываем handleTouchOutside один раз
      if !isTouchInsideAnyWidget {
        handleTouchOutside(isTouchInsideNavigationBar: isTouchInsideNavigationBar)
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
        currencyRates: presenter.appSettingsModel.allCurrencyRate,
        availableCurrencyRate: presenter.appSettingsModel.selectedCurrencyRate,
        currencyTypes: presenter.appSettingsModel.currencyTypes,
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
            .if(
              (CurrencyRate.Currency(rawValue: model.additionalID) ?? .USD == presenter.appSettingsModel.activeCurrency),
              transform: { view in
                view
                  .overlay(
                    RoundedRectangle(cornerRadius: .s3)
                      .stroke(SKStyleAsset.constantAzure.swiftUIColor, lineWidth: 0.5)
                  )
              }
            )
            .background(
              GeometryReader { geometry in
                Color.clear
                  .onAppear {
                    widgetFrames[model.additionalID] = geometry.frame(in: .global)
                  }
                  .onChange(of: geometry.frame(in: .global)) { newFrame in
                    widgetFrames[model.additionalID] = newFrame
                  }
              }
            )
        }
        .listRowBackground(SKStyleAsset.onyx.swiftUIColor)
        .listRowInsets(.init(top: 0.5, leading: .s4, bottom: 0.5, trailing: .s4))
        .listRowSeparator(.hidden)
      }
      .onMove(perform: move)
      .onDelete(perform: deleteItems)
    }
    .background(Color.clear)
    .listStyle(PlainListStyle())
    .listRowSpacing(.s4)
    .listRowSeparator(.hidden)
  }
  
  func move(from source: IndexSet, to destination: Int) {
    Task {
      await presenter.moveCurrencyRates(from: source, to: destination)
    }
  }
  
  func deleteItems(at offsets: IndexSet) {
    for index in offsets {
      let model = presenter.currencyWidgets[index]
      Task {
        // Выполняем задержку без блокировки потока
        try? await withCheckedThrowingContinuation { continuation in
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            continuation.resume()
          }
        }
        await presenter.userRemoveCurrencyRate(currencyAlpha: model.additionalID)
      }
    }
    presenter.currencyWidgets.remove(atOffsets: offsets)
  }
  
  // Действие при касании вне всех WidgetCryptoView и навигационной панели
  func handleTouchOutside(isTouchInsideNavigationBar: Bool) {
    Task {
      let appSettingsModel = presenter.appSettingsModel
      
      // Если касание внутри навигационной панели, выполняем проверку состояний
      if isTouchInsideNavigationBar {
        // Если isUserInputVisible, игнорируем касание
        if appSettingsModel.isUserInputVisible {
          return
        }
      }
      
      Task {
        // Скрыть клавиатуру, если она видима
        if appSettingsModel.isUserInputVisible {
          await presenter.setKeyboardIsShown(false, appSettingsModel.activeCurrency)
        }
      }
    }
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
