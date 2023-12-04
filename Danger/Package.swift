// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dangerfile",
    platforms: [.macOS("10.15")],
    products: [
        .library(
            name: "DangerDepsProduct",
            type: .dynamic,
            targets: ["DangerDependencies"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.53.0"),
        // Danger
        .package(name: "danger-swift", url: "https://github.com/danger/swift.git", from: "3.18.0"),
        // Danger Plugins
        .package(name: "DangerSwiftEda", url: "https://github.com/yumemi-inc/danger-swift-eda", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "DangerDependencies",
            dependencies: [
                .product(name: "Danger", package: "danger-swift"),
                "DangerSwiftEda",
            ]
        ),
    ]
)
