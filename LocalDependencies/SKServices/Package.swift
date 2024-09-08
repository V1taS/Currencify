// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SKServices",
  defaultLocalization: "en",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "SKServices",
      targets: ["SKServices"]
    ),
  ],
  dependencies: [
    .package(path: "../../LocalDependencies/SKStyle"),
    .package(path: "../../LocalDependencies/SKAbstractions"),
    .package(path: "../../LocalDependencies/SKFoundation"),
    .package(path: "../../LocalDependencies/SKNotifications"),
    .package(url: "https://github.com/apphud/ApphudSDK", exact: "3.4.0")
  ],
  targets: [
    .target(
      name: "SKServices",
      dependencies: [
        "SKStyle",
        "SKAbstractions",
        "SKFoundation",
        "SKNotifications",
        "ApphudSDK"
      ]
    )
  ]
)
