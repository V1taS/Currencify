//
//  MainScreenPresenter.swift
//  Currencify
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SKStyle
import SKUIKit
import SwiftUI
import SKAbstractions

final class MainScreenPresenter: ObservableObject {
  
  // MARK: - View state
  
  @Published var currencyWidgets: [WidgetCryptoView.Model] = []
  @Published var isCurrencyListEmpty = false
  @Published var isSearchViewVisible = false
  @Published var isEditMode: EditMode = .inactive
  @Published var appSettingsModel: AppSettingsModel = .setDefaultValues()
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let factory: MainScreenFactoryInput
  private var rightBarSettingsButton: SKBarButtonItem?
  private var rightBarShareButton: SKBarButtonItem?
  private var leftBarAddButton: SKBarButtonItem?
  private var rawCurrencyRate: String = "0"
  private var currencyRateIdentifiable: [CurrencyRateIdentifiable] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: Интерактор
  ///   - factory: Фабрика
  init(interactor: MainScreenInteractorInput,
       factory: MainScreenFactoryInput) {
    self.interactor = interactor
    self.factory = factory
  }
  
  // MARK: - The lifecycle of a UIViewController
  
  lazy var viewDidLoad: (() -> Void)? = {}
  
  /// Метод, вызываемый перед появлением представления; проверяет режим Premium.
  lazy var viewWillAppear: (() -> Void)? = { [weak self] in
    guard let self else { return }
    
    Task { [weak self] in
      guard let self, await !interactor.getAppSettingsModel().allCurrencyRate.isEmpty else { return }
      await createCurrencyWidget()
    }
    
    if interactor.isReachable {
      Task { [weak self] in
        guard let self else { return }
        await interactor.fetchCurrencyRates()
        await moduleOutput?.premiumModeCheck()
      }
    }
  }
  
  // MARK: - Internal func
  
  /// Обновляет данные о курсах валют и создает виджеты валют.
  func refreshCurrencyData() async {
    guard interactor.isReachable else { return }
    await interactor.fetchCurrencyRates()
    await createCurrencyWidget()
  }
  
  /// Добавляет новую валюту в список выбранных пользователем.
  /// - Parameter newValue: Новая валюта для добавления.
  func userAddCurrencyRate(newValue: CurrencyRate) async {
    let appSettingsModel = await getAppSettingsModel()
    isSearchViewVisible = false
    
    if !appSettingsModel.isPremium,
       appSettingsModel.selectedCurrencyRate.count >= 3 {
      await moduleOutput?.limitOfAddedCurrenciesHasBeenExceeded()
      return
    }
    
    let newValueArray = [newValue.currency]
    await interactor.setSelectedCurrencyRates(newValueArray)
    await createCurrencyWidget()
  }
  
  /// Удаляет валюту из списка выбранных пользователем.
  /// - Parameter currencyAlpha: Код валюты для удаления.
  func userRemoveCurrencyRate(currencyAlpha: String) async {
    let appSettingsModel = await getAppSettingsModel()
    guard let currency = CurrencyRate.Currency(rawValue: currencyAlpha) else {
      return
    }
    
    if appSettingsModel.activeCurrency == currency {
      await interactor.setUserInputIsVisible(false)
      await interactor.setEnteredCurrencyAmountRaw("0")
      await interactor.setActiveCurrency(appSettingsModel.activeCurrency)
    }
    
    await interactor.removeCurrencyRates([currency])
    await createCurrencyWidget()
  }
  
  /// Перемещает валюты в списке по заданным индексам.
  /// - Parameters:
  ///   - source: Индексы исходных элементов.
  ///   - destination: Индекс назначения.
  @MainActor
  func moveCurrencyRates(from source: IndexSet, to destination: Int) async {
    let appSettingsModel = await getAppSettingsModel()
    
    currencyWidgets.move(fromOffsets: source, toOffset: destination)
    var selectedCurrencyRate = appSettingsModel.selectedCurrencyRate
    selectedCurrencyRate.move(fromOffsets: source, toOffset: destination)
    
    await interactor.removeAllCurrencyRates()
    await interactor.setSelectedCurrencyRates(selectedCurrencyRate)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      Task { [weak self] in
        guard let self else { return }
        await self.createCurrencyWidget()
      }
    }
  }
  
  /// Пересчитывает значения виджетов валют.
  @MainActor
  func recalculateCurrencyWidgets() async {
    let appSettingsModel = await getAppSettingsModel()
    
    currencyRateIdentifiable = await interactor.recalculateCurrencyRates(
      appSettingsModel: appSettingsModel,
      rawCurrencyRate: rawCurrencyRate
    )
    await validateRatesData()
    await setCurrencyRateText()
  }
  
  /// Создает виджеты валют на основе текущих данных.
  @MainActor
  func createCurrencyWidget() async {
    let appSettingsModel = await getAppSettingsModel()
    
    rawCurrencyRate = await getEnteredCurrencyAmountRaw(appSettingsModel)
    await recalculateCurrencyWidgets()
    currencyWidgets = factory.createCurrencyWidgetModels(
      decimalPlaces: appSettingsModel.currencyDecimalPlaces,
      currencyRateIdentifiables: currencyRateIdentifiable
    )
    await setCurrencyRateText()
    await setKeyboardIsShown(appSettingsModel.isUserInputVisible, appSettingsModel.activeCurrency)
  }
  
  /// Получает текущую модель настроек приложения.
  @MainActor
  func getAppSettingsModel() async -> AppSettingsModel {
    let appSettingsModel = await interactor.getAppSettingsModel()
    self.appSettingsModel = appSettingsModel
    return appSettingsModel
  }
  
  /// Устанавливает видимость пользовательского ввода.
  /// - Parameter value: Логическое значение видимости.
  func setUserInputIsVisible(_ value: Bool) async {
    await interactor.setUserInputIsVisible(value)
  }
  
  /// Устанавливает состояние клавиатуры для заданной валюты.
  /// - Parameters:
  ///   - value: Логическое значение отображения клавиатуры.
  ///   - currency: Выбранная валюта.
  func setKeyboardIsShown(_ value: Bool, _ currency: CurrencyRate.Currency) async {
    await interactor.setUserInputIsVisible(value)
    resetKeyboardShownState()
    
    if let (currencyWidgetsModel, currencyRateIdentifiableModel) = getCurrencyModels(for: currency) {
      updateKeyboardModel(for: currencyWidgetsModel, with: currencyRateIdentifiableModel, isShown: value)
      rawCurrencyRate = currencyRateIdentifiableModel.rateText
    }
  }
}

// MARK: - MainScreenModuleInput

extension MainScreenPresenter: MainScreenModuleInput {}

// MARK: - MainScreenInteractorOutput

extension MainScreenPresenter: MainScreenInteractorOutput {}

// MARK: - MainScreenFactoryOutput

extension MainScreenPresenter: MainScreenFactoryOutput {
  
  /// Обрабатывает ввод суммы пользователем.
  /// - Parameter newValue: Новое введенное значение.
  func userDidEnterAmount(_ newValue: String) async {
    let modifiedValue = modifyAmount(newValue)
    let appSettingsModel = await getAppSettingsModel()
    
    await setRawCurrencyRate(newValue: modifiedValue)
    
    if let countCharactersAfterComma = interactor.textFormatterService.countCharactersAfterComma(in: modifiedValue),
       countCharactersAfterComma > appSettingsModel.currencyDecimalPlaces.rawValue {
      triggerHapticFeedback(.error)
    }
    await recalculateCurrencyWidgets()
  }
  
  /// Обрабатывает выбор валюты пользователем.
  /// - Parameter currency: Выбранная валюта.
  func userDidSelectCurrency(_ currency: CurrencyRate.Currency) async {
    let appSettingsModel = await getAppSettingsModel()
    
    if appSettingsModel.activeCurrency == currency && appSettingsModel.isUserInputVisible {
      await interactor.setActiveCurrency(currency)
      await setKeyboardIsShown(false, currency)
      await recalculateCurrencyWidgets()
      return
    }
    
    await interactor.setActiveCurrency(currency)
    if let (_, currencyRateIdentifiableModel) = getCurrencyModels(for: currency) {
      rawCurrencyRate = currencyRateIdentifiableModel.rateText
    }
    
    await saveEnteredCurrencyAmountRaw()
    await setKeyboardIsShown(true, currency)
    await recalculateCurrencyWidgets()
  }
}

// MARK: - SceneViewModel

extension MainScreenPresenter: SceneViewModel {
  var sceneTitle: String? { Constants.title }
  var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode { .always }
  
  var leftBarButtonItems: [SKBarButtonItem] {
    [
      .init(
        .add(
          action: { [weak self] in
            DispatchQueue.main.async { [weak self] in
              self?.isSearchViewVisible = true
            }
          }, buttonItem: { [weak self] buttonItem in
            self?.leftBarAddButton = buttonItem
          }
        )
      )
    ]
  }
  
  var rightBarButtonItems: [SKBarButtonItem] {
    [
      .init(
        .share(
          action: { [weak self] in
            Task { [weak self] in
              guard let self else { return }
              if await interactor.requestGallery() {
                await self.createCollectionViewSnapshot()
              }
            }
          }, buttonItem: { [weak self] buttonItem in
            self?.rightBarShareButton = buttonItem
          }
        )
      ),
      .init(
        .settings(
          action: { [weak self] in
            DispatchQueue.main.async { [weak self] in
              self?.moduleOutput?.openSettinsScreen()
            }
          }, buttonItem: { [weak self] buttonItem in
            self?.rightBarSettingsButton = buttonItem
          }
        )
      )
    ]
  }
}

// MARK: - Private

private extension MainScreenPresenter {
  
  /// Проверяет данные о курсах валют и обновляет состояние видимости элементов.
  @MainActor
  func validateRatesData() async {
    let appSettingsModel = await getAppSettingsModel()
    isCurrencyListEmpty = appSettingsModel.allCurrencyRate.isEmpty
    leftBarAddButton?.isEnabled = !appSettingsModel.allCurrencyRate.isEmpty
    rightBarShareButton?.isEnabled = !appSettingsModel.allCurrencyRate.isEmpty
  }
  
  /// Создает снимок коллекции виджетов и открывает его в просмотрщике изображений.
  func createCollectionViewSnapshot() async {
    let finalImage = await interactor.createCollectionViewSnapshot()
    await moduleOutput?.openImageViewer(image: finalImage)
  }
  
  /// Инициирует тактильную обратную связь указанного типа.
  /// - Parameter type: Тип обратной связи.
  func triggerHapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(type)
  }
  
  /// Устанавливает текстовые значения курсов валют в виджетах.
  @MainActor
  func setCurrencyRateText() async {
    let appSettingsModel = await getAppSettingsModel()
    
    for currencyWidgetsModel in currencyWidgets {
      if let currencyRateIdentifiableModel = currencyRateIdentifiable.first(
        where: {
          $0.currency.rawValue == currencyWidgetsModel.additionalID
        }) {
        updateCurrencyWidgetsModel(currencyWidgetsModel, with: currencyRateIdentifiableModel)
      }
    }
    
    if let (currencyWidgetsModel, currencyRateIdentifiableModel) = getCurrencyModels(for: appSettingsModel.activeCurrency) {
      if let keyboardModelUpdate = currencyWidgetsModel.keyboardModel {
        let countCharactersAfterComma = interactor.textFormatterService.countCharactersAfterComma(
          in: currencyRateIdentifiableModel.rateText
        ) ?? .zero
        keyboardModelUpdate.keyboardIsBlock = countCharactersAfterComma >= appSettingsModel.currencyDecimalPlaces.rawValue
        currencyWidgetsModel.keyboardModel = keyboardModelUpdate
      }
    }
  }
  
  /// Модифицирует введенную сумму, приводя ее к корректному формату.
  /// - Parameter newValue: Введенное значение.
  /// - Returns: Модифицированное значение.
  func modifyAmount(_ newValue: String) -> String {
    let onlyCommaValue = newValue == "," ? "0," : newValue
    return onlyCommaValue.isEmpty ? "0" : onlyCommaValue
  }
  
  /// Устанавливает необработанное значение курса валюты.
  /// - Parameter newValue: Новое значение.
  func setRawCurrencyRate(newValue: String) async {
    let newValueProcessed = interactor.textFormatterService.removeLeadingZeroIfNoComma(
      in: interactor.textFormatterService.replaceDoubleZeroWithZero(in: newValue)
    )
    
    let rawClearedTextCurrencyRate = interactor.textFormatterService.removeAllSpaces(from: newValueProcessed)
    rawCurrencyRate = interactor.textFormatterService.formatNumberWithThousands(rawClearedTextCurrencyRate)
    await saveEnteredCurrencyAmountRaw()
  }
  
  /// Сохраняет введенную пользователем сумму в необработанном виде.
  func saveEnteredCurrencyAmountRaw() async {
    let newValueProcessed = interactor.textFormatterService.replaceCommasWithDots(
      in: interactor.textFormatterService.removeAllSpaces(from: rawCurrencyRate)
    )
    await interactor.setEnteredCurrencyAmountRaw(newValueProcessed)
  }
  
  /// Получает введенную пользователем сумму из настроек приложения.
  /// - Parameter appSettingsModel: Модель настроек приложения.
  /// - Returns: Введенная сумма в виде строки.
  func getEnteredCurrencyAmountRaw(_ appSettingsModel: AppSettingsModel) async -> String {
    let enteredCurrencyAmountRaw = appSettingsModel.enteredCurrencyAmountRaw
    let rawReplaceDotsWithCommas = interactor.textFormatterService.replaceDotsWithCommas(in: enteredCurrencyAmountRaw)
    return interactor.textFormatterService.formatNumberWithThousands(rawReplaceDotsWithCommas)
  }
  
  /// Сбрасывает состояние отображения клавиатуры для всех виджетов.
  func resetKeyboardShownState() {
    for model in currencyWidgets {
      if let keyboardModelUpdate = model.keyboardModel {
        keyboardModelUpdate.isKeyboardShown = false
        model.keyboardModel = keyboardModelUpdate
      }
    }
  }
  
  /// Получает модели виджета и идентифицируемого курса валюты для заданной валюты.
  /// - Parameter currency: Валюта.
  /// - Returns: Кортеж с моделями виджета и курса валюты или `nil`, если не найдено.
  func getCurrencyModels(for currency: CurrencyRate.Currency) -> (WidgetCryptoView.Model, CurrencyRateIdentifiable)? {
    guard let currencyWidgetsModel = currencyWidgets.first(where: { $0.additionalID == currency.rawValue }),
          let currencyRateIdentifiableModel = currencyRateIdentifiable.first(where: { $0.currency.rawValue == currency.rawValue }) else {
      return nil
    }
    return (currencyWidgetsModel, currencyRateIdentifiableModel)
  }
  
  /// Обновляет модель виджета валюты данными из идентифицируемой модели курса.
  /// - Parameters:
  ///   - currencyWidgetsModel: Модель виджета валюты.
  ///   - currencyRateIdentifiableModel: Модель идентифицируемого курса валюты.
  func updateCurrencyWidgetsModel(
    _ currencyWidgetsModel: WidgetCryptoView.Model,
    with currencyRateIdentifiableModel: CurrencyRateIdentifiable
  ) {
    if let rightSideLargeTextModel = currencyWidgetsModel.rightSideLargeTextModel {
      rightSideLargeTextModel.text = currencyRateIdentifiableModel.rateText
      rightSideLargeTextModel.textStyle = currencyRateIdentifiableModel.rateDouble == .zero ? .netural : .standart
      currencyWidgetsModel.rightSideLargeTextModel = rightSideLargeTextModel
    }
    
    if let keyboardModelUpdate = currencyWidgetsModel.keyboardModel {
      keyboardModelUpdate.value = currencyRateIdentifiableModel.rateText
      currencyWidgetsModel.keyboardModel = keyboardModelUpdate
    }
  }
  
  /// Обновляет модель клавиатуры для заданного виджета валюты.
  /// - Parameters:
  ///   - currencyWidgetsModel: Модель виджета валюты.
  ///   - currencyRateIdentifiableModel: Модель идентифицируемого курса валюты.
  ///   - isShown: Логическое значение отображения клавиатуры.
  func updateKeyboardModel(
    for currencyWidgetsModel: WidgetCryptoView.Model,
    with currencyRateIdentifiableModel: CurrencyRateIdentifiable,
    isShown: Bool
  ) {
    if let keyboardModelUpdate = currencyWidgetsModel.keyboardModel {
      keyboardModelUpdate.isKeyboardShown = isShown
      keyboardModelUpdate.value = currencyRateIdentifiableModel.rateText
      currencyWidgetsModel.keyboardModel = keyboardModelUpdate
    }
  }
}

// MARK: - Constants

private enum Constants {
  static let title = "Currencify"
}
