import Foundation

// MARK: - Public property

public enum Constants {
  // App
  static public let organizationName = "SosinVitalii.com"
  static public let reverseOrganizationName = "com.sosinvitalii"
  static public let appNameRelease = "Currencify"
  static public let appDisplayName = "Currencify"
  static public let appNameDebug = "Currencify-Dev"
  static public let rootPath = "Currencify"
  static public let appPath = "App"
  static public let dependenciesPath = "LocalDependencies"
  static public let bundleApp = "com.sosinvitalii.Currencify"
  static public let developmentRegion = "en"

  // Settings
  static public let iOSTargetVersion = "16.0"
  static public let developmentTeam = "34VDSPZYU9"
  
  /// If you pass the key `PRODUCT_BUNDLE_IDENTIFIER` in settings, this method can set additional name for you.
  /// - Parameter name: Additional name for $(PRODUCT_BUNDLE_IDENTIFIER).
  /// - Returns: $(PRODUCT_BUNDLE_IDENTIFIER) + name.
  public static func bundleIdentifier(name: String? = nil) -> String {
      return bundleApp + (name.flatMap { ".\($0)" } ?? "")
  }
}
