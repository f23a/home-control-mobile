// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeControlShared",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "HomeControlShared",
            targets: ["HomeControlShared"]
        )
    ],
    dependencies: [
//        .package(path: "../../home-control-client"),
        .package(url: "https://github.com/f23a/home-control-client.git", from: "1.7.1"),
        .package(url: "https://github.com/f23a/home-control-logging.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "HomeControlShared",
            dependencies: [
                .product(name: "HomeControlClient", package: "home-control-client"),
                .product(name: "HomeControlLogging", package: "home-control-logging")
            ]
        ),
        .testTarget(
            name: "HomeControlSharedTests",
            dependencies: ["HomeControlShared"]
        )
    ]
)
