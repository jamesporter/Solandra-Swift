// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Solandra",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "Solandra",
      targets: ["Solandra"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.10.0"
    ),
    .package(url: "https://github.com/jamesporter/PseudoRandom", branch: "main"),
    .package(url: "https://github.com/jamesporter/CGExtensions", branch: "main"),
  ],
  targets: [
    .target(
      name: "Solandra",
      dependencies: ["PseudoRandom", "CGExtensions"]),
    .testTarget(
      name: "SolandraTests",
      dependencies: [
        "Solandra",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ]),
  ]
)
