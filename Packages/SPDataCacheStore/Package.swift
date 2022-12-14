// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPDataCacheStore",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SPDataCacheStore",
            targets: ["SPDataCacheStore"]
        )
    ],
    dependencies: [
        .package(name: "SPError", path: "../SPError"),
        .package(name: "SPLogger", path: "../SPLogger")
    ],
    targets: [
        .target(
            name: "SPDataCacheStore",
            dependencies: [
                "SPError",
                "SPLogger"
            ],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        ),
        .testTarget(
            name: "SPDataCacheStoreTests",
            dependencies: ["SPDataCacheStore"],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        )
    ]
)
