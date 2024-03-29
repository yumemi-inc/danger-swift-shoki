// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DangerSwiftShoki",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DangerSwiftShoki",
            type: .dynamic,
            targets: ["DangerSwiftShoki"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/danger/swift.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DangerSwiftShoki",
            dependencies: [
                .product(name: "Danger", package: "swift")
            ]
        ),
        .testTarget(
            name: "DangerSwiftShokiTests",
            dependencies: ["DangerSwiftShoki"]
        ),
    ]
)
