// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPLogger",
    platforms: [
        .iOS(.v14),
        .watchOS(.v7),
        .tvOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SPLogger",
            targets: ["SPLogger"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SPLogger",
            dependencies: [],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        )
    ]
)
