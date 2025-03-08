// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AstroSummaryCore",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FileClient",
            targets: ["FileClient"]),
        .library(
            name: "FoundationExtensions",
            targets: ["FoundationExtensions"]),
        .library(
            name: "Models",
            targets: ["Models"]),
        .library(
            name: "SummaryFeature",
            targets: ["SummaryFeature"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FileClient",
            dependencies: ["Models"]),
        .testTarget(
            name: "FileClientTests",
            dependencies: ["FileClient",
                           "Models"],
            resources: [.copy("TestResources")]),
        .target(
            name: "FoundationExtensions"),
        .testTarget(
            name: "FoundationExtensionsTests",
            dependencies: ["FoundationExtensions"]),
        .target(
            name: "Models",
            dependencies: ["FoundationExtensions"]),
        .testTarget(
            name: "ModelsTests",
            dependencies: ["FoundationExtensions",
                           "Models"]),
        .target(
            name: "SummaryFeature",
            dependencies: ["FileClient",
                          "Models"]),
    ]
)
