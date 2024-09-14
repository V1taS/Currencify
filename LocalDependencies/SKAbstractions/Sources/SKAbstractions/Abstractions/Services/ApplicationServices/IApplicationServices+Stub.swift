//
//  IApplicationServices+Stub.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 31.05.2024.
//

import SwiftUI
import StoreKit

// MARK: - ServicesStub

public final class ApplicationServicesStub: IApplicationServices, IDataManagerService, IDataMappingService,
                                            INotificationService, IPermissionService,
                                            ISystemService, IUIService,
                                            IAnalyticsService, ISecureDataManagerService,
                                            IDataManagementService,
                                            IAccessAndSecurityManagementService, IUserInterfaceAndExperienceService,
                                            IAppSettingsDataManager, IAppPurchasesService, ICloudKitService, ICurrencyRatesService {
  public func setRateCorrectionPercentage(_ value: Double, completion: @escaping () -> Void) {}
  public func setCurrencyDecimalPlaces(_ value: CurrencyDecimalPlaces, completion: @escaping () -> Void) {}
  public func setCurrencySource(_ value: CurrencySource, completion: @escaping () -> Void) {}
  public func fetchECBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void) {}
  public func setSelectedCurrencyRates(_ currencyRates: [CurrencyRate.Currency], completion: @escaping () -> Void) {}
  public func removeCurrencyRates(_ currencyRates: [CurrencyRate.Currency], completion: @escaping () -> Void) {}
  public func removeAllCurrencyRates(completion: @escaping () -> Void) {}
  public func fetchCBCurrencyRates(completion: @escaping ([CurrencyRate]) -> Void) {}
  public var currencyRatesService: any ICurrencyRatesService { self }
  public func saveAppSettingsModel(_ model: AppSettingsModel, completion: @escaping () -> Void) {}
  public func setIsPremiumEnabled(_ value: Bool, completion: @escaping () -> Void) {}
  public func getConfigurationValue<T>(from keyName: String, completion: @escaping (Result<T?, any Error>) -> Void) {}
  public var cloudKitService: any ICloudKitService { self }
  public func getProducts(completion: @escaping ([SKProduct]) -> Void) {}
  public func purchaseWith(_ productIdentifiers: String, completion: @escaping (AppPurchasesServiceState) -> Void) {}
  public func restorePurchase(completion: @escaping (Bool) -> Void) {}
  public func isValidatePurchase(completion: @escaping (Bool) -> Void) {}
  public var appPurchasesService: any IAppPurchasesService { self }
  public func openSettings() async -> Result<Void, SystemServiceError> { .success(())}
  public func copyToClipboard(text: String, completion: @escaping (Result<Void, SystemServiceError>) -> Void) {}
  public func openURLInSafari(urlString: String, completion: @escaping (Result<Void, SystemServiceError>) -> Void) {}
  public func checkIfPasscodeIsSet() async -> Result<Void, SystemServiceError> { .success(()) }
  public func setSecretKey(_ value: String) async {}
  public init() {}
  public func getAppSettingsModel() async -> AppSettingsModel { .setDefaultValues() }
  public func saveAppSettingsModel(_ model: AppSettingsModel) async { }
  public func saveMyPushNotificationToken(_ token: String) async { }
  public func setToxStateAsString(_ toxStateAsString: String?) async { }
  public var appSettingsDataManager: any IAppSettingsDataManager { self }
  public func setFakeAppPassword(_ value: String?) async {}
  public func setIsFakeAccessEnabled(_ value: Bool) async {}
  public func setIsPremiumEnabled(_ value: Bool) async {}
  public func setIsTypingIndicatorEnabled(_ value: Bool) async {}
  public func setCanSaveMedia(_ value: Bool) async {}
  public func setIsChatHistoryStored(_ value: Bool) async {}
  public func setIsVoiceChangerEnabled(_ value: Bool) async {}
  public func setIsEnabledFaceID(_ value: Bool) async {}
  public func setAppPassword(_ value: String?) async {}
  public func setIsEnabledNotifications(_ value: Bool) async {}
  public func setIsNewMessagesAvailable(_ value: Bool, toxAddress: String) async {}
  public func encodeModel<T>(_ model: T) async throws -> Data? where T : Encodable { nil }
  public func decodeModel<T>(_ type: T.Type, from data: Data) async throws -> T? where T : Decodable { nil }
  public func requestNotification() async -> Bool { false}
  public func isNotificationsEnabled() async -> Bool { false }
  public func requestCamera() async -> Bool { false }
  public func requestGallery() async -> Bool { false }
  public func requestFaceID() async -> Bool { false }
  public func saveImageToGallery(_ imageData: Data?) async -> Bool { false }
  public func saveVideoToGallery(_ video: URL?) async -> Bool { false }
  public func getConfigurationValue<T>(from keyName: String) async throws -> T? { nil }
  public func saveDeepLinkURL(_ url: URL) async { }
  public func getMessengerAddress() async -> String? { nil }
  public func isFirstLaunch() -> Bool { false }
  public func saveVideoToGallery(_ video: URL?, completion: ((Bool) -> Void)?) {}
  public func getFileNameWithoutExtension(from url: URL) -> String { "" }
  public func getFileName(from url: URL) -> String? { nil }
  public func constructFileURL(fileName: String, fileExtension: String?) -> URL? { nil }
  public func saveObjectToCachesWith(fileName: String, fileExtension: String, data: Data) -> URL? { nil }
  public func clearTemporaryDirectory() {}
  public func saveObjectWith(tempURL: URL) -> URL? {  nil }
  public func zipFiles(atPaths paths: [URL], toDestination destinationPath: URL, password: String?, progress: ((Double) -> ())?) throws {}
  public func unzipFile(atPath path: URL, toDestination destinationPath: URL, overwrite: Bool, password: String?, progress: ((Double) -> ())?, fileOutputHandler: ((URL) -> Void)?) throws {}
  public func decrypt(_ data: Data?, privateKey: String) -> Data? { nil }
  public func encrypt(_ data: Data?, publicKey: String) -> Data? { nil }
  public func setIsNewMessagesAvailable(_ value: Bool, toxAddress: String, completion: (() -> Void)?) {}
  public func sendPushNotification(title: String, body: String, customData: [String : Any], deviceToken: String) {}
  public func setAllContactsIsOffline(completion: (() -> Void)?) {}
  public func saveDeepLinkURL(_ url: URL, completion: (() -> Void)?) {}
  public func deleteDeepLinkURL() {}
  public func getMessengerAdress(completion: ((String?) -> Void)?) {}
  public func generateQRCode(from string: String, backgroundColor: Color, foregroundColor: Color, iconIntoQR: UIImage?, iconSize: CGSize, iconBackgroundColor: Color?, completion: ((UIImage?) -> Void)?) {}
  public func deleteAllData() -> Bool { false }
  public func getDataManagerService() -> any IDataManagerService { self }
  public func getDataMappingService() -> any IDataMappingService { self }
  public func getNotificationService() -> any INotificationService { self }
  public func getPermissionService() -> any IPermissionService { self }
  public func getSystemService() -> any ISystemService { self }
  public func getUIService() -> any IUIService { self }
  public func getAnalyticsService() -> any IAnalyticsService { self }
  public func getSecureDataManagerService(_ serviceName: SecureDataManagerServiceKey) -> any ISecureDataManagerService { self }
  public func getDataManagementService() -> any IDataManagementService { self }
  public func getAccessAndSecurityManagementService() -> any IAccessAndSecurityManagementService { self }
  public func getUserInterfaceAndExperienceService() -> any IUserInterfaceAndExperienceService { self }
  public var dataManagementService: any IDataManagementService { self }
  public var accessAndSecurityManagementService: any IAccessAndSecurityManagementService { self }
  public var userInterfaceAndExperienceService: any IUserInterfaceAndExperienceService { self }
  public var analyticsService: any IAnalyticsService { self }
  public var permissionService: any IPermissionService { self }
  public var dataManagerService: any IDataManagerService { self }
  public var dataMappingService: any IDataMappingService { self }
  public var uiService: any IUIService { self }
  public var systemService: any ISystemService { self }
  public var notificationService: any INotificationService { self }
  public func loadFromKeychain(completion: @escaping (Result<Data, any Error>) -> Void) {}
  public func saveToKeychain(_ data: Data, completion: @escaping (Result<Void, any Error>) -> Void) {}
  public func removeFromKeychain(completion: @escaping (Result<Void, any Error>) -> Void) {}
  public func encodeModel<T>(_ model: T, completion: @escaping (Result<Data, any Error>) -> Void) where T : Encodable {}
  public func decodeModel<T>(_ type: T.Type, from data: Data, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {}
  public func showNotification(_ type: NotificationServiceType, action: (() -> Void)?) {}
  public func showNotification(_ type: NotificationServiceType) {}
  public func requestNotification(completion: @escaping (Bool) -> Void) {}
  public func isNotificationsEnabled(completion: @escaping (Bool) -> Void) {}
  public func requestCamera(completion: @escaping (Bool) -> Void) {}
  public func requestGallery(completion: @escaping (Bool) -> Void) {}
  public func requestFaceID(completion: @escaping (Bool) -> Void) {}
  public func startSession() {}
  public func endSession() {}
  public func isSessionActive() -> Bool { false }
  public func updateLastActivityTime() {}
  public func openSettings() {}
  public func saveColorScheme(_ interfaceStyle: UIUserInterfaceStyle?) {}
  public func getColorScheme() -> UIUserInterfaceStyle? { nil }
  public func saveImageToGallery(_ imageData: Data?, completion: ((Bool) -> Void)?) {}
  public func copyToClipboard(text: String) {}
  public func generateQRCode(from string: String, iconIntoQR: UIImage?, completion: ((UIImage?) -> Void)?) {}
  public func generateQRCode(from string: String, backgroundColor: Color, foregroundColor: Color, iconIntoQR: UIImage?, iconSize: CGSize, completion: ((UIImage?) -> Void)?) {}
  public func saveObjectWith(fileName: String, fileExtension: String, data: Data) -> URL? { nil }
  public func readObjectWith(fileURL: URL) -> Data? { nil }
  public func deleteObjectWith(fileURL: URL, isRemoved: ((Bool) -> Void)?) {}
  public func openURLInSafari(urlString: String) {}
  public func getCurrentLanguage() -> AppLanguageType { .russian }
  public func trackEvent(_ event: String, parameters: [String : Any]) {}
  public func log(_ message: String) {}
  public func error(_ error: String, file: String, function: String, line: Int) {}
  public func error(_ error: any Error, file: String, function: String, line: Int) {}
  public func getAllLogs() -> URL? { nil }
  public func getErrorLogs() -> URL? { nil }
  public func clearAllLogs() {}
  public func getDeviceModel() -> String { "" }
  public func getSystemName() -> String { "" }
  public func getSystemVersion() -> String { "" }
  public func getDeviceIdentifier() -> String { "" }
  public func getAppVersion() -> String { "" }
  public func getAppBuildNumber() -> String { "" }
  public func publicKey(from privateKey: String) throws -> String { "" }
  public func encrypt(_ message: String, publicKey: String) throws -> String { "" }
  public func decrypt(_ message: String, privateKey: String) throws -> String { "" }
  public func setTheirPublicKey(_ key: String?) {}
  public func prepareMessage(_ message: String?) -> String? { nil }
  public func handleReceiveMessages(_ message: String?) -> (theirPublicKey: String?, message: String?) { (nil, nil)}
  public func string(for key: String) -> String? { nil }
  public func data(for key: String) -> Data? { nil }
  public func deleteData(for key: String) -> Bool { false }
  public func save(string: String, key: String) -> Bool { false }
  public func save(data: Data, key: String) -> Bool { false }
  public func model<T>(for key: String) -> T? where T : Decodable { nil }
  public func publicKey(from privateKey: String) -> String? { nil }
  public func encrypt(_ data: String?, publicKey: String) -> String? { nil }
  public func decrypt(_ encryptedData: String?, privateKey: String) -> String? { nil }
  public var sessionDidExpireAction: (() -> Void)?
  public func getString(for key: String) -> String? { nil }
  public func getData(for key: String) -> Data? { nil }
  public func getModel<T>(for key: String) -> T? where T : Decodable { nil }
  public func saveString(_ string: String, key: String) -> Bool { false }
  public func saveData(_ data: Data, key: String) -> Bool { false }
  public func saveModel<T>(_ model: T, for key: String) -> Bool where T : Encodable { false}
  public func sessionDidExpire() {}
  public func getConfigurationValue<T>(from keyName: String, completion: @escaping (T?) -> Void) {}
  public func getImage(for url: URL?, completion: @escaping (UIImage?) -> Void) {}
  public func getAppSettingsModel(completion: @escaping (AppSettingsModel) -> Void) {}
  public func saveAppSettingsModel(_ model: AppSettingsModel, completion: (() -> Void)?) {}
  public func setIsEnabledFaceID(_ value: Bool, completion: (() -> Void)?) {}
  public func setAppPassword(_ value: String?, completion: (() -> Void)?) {}
  public func setIsEnabledNotifications(_ value: Bool, completion: (() -> Void)?) {}
  public func createWallet12Words() -> String? { nil }
  public func createWallet24Words() -> String? { nil }
  public func recoverMnemonic(_ mnemonic: String) -> String? { nil }
  public func isValidMnemonic(_ input: String) -> Bool { false }
  public func isValidPrivateKey(_ input: String) -> Bool { false }
  public func getWalletDetails(mnemonic: String) -> (publicKey: String, privateKey: String)? { nil }
  public func sha512(from input: String) -> String { "" }
  public func sha512(from inputData: Data) -> String { "" }
  public func sha256(from input: String) -> String { "" }
  public func sha256(from inputData: Data) -> String { "" }
}
