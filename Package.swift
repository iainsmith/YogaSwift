// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "YogaSwift",
  platforms: [.macOS(.v12), .iOS(.v15)],
  products: [
    .library(
      name: "YogaSwift",
      targets: ["YogaSwift"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/iainsmith/yoga.git", .upToNextMajor(from: "3.1.1")),
    .package(url: "https://github.com/apple/swift-syntax", exact: "600.0.0-prerelease-2024-07-24"),
  ],
  targets: [
    .target(
      name: "YogaSwift",
      dependencies: [
        .product(name: "yoga", package: "yoga"),
        "YogaMacros",
      ]
    ),
    .target(
      name: "YogaMacros",
      dependencies: ["YogaMacrosPlugin"]
    ),
    .macro(
      name: "YogaMacrosPlugin",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),

    .testTarget(
      name: "YogaSwiftTests",
      dependencies: ["YogaSwift"]
    ),
  ]
)
