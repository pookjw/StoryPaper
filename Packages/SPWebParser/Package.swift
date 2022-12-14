// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPWebParser",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SPWebParser",
            targets: ["SPWebParser"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
        .package(name: "SPError", path: "../SPError"),
        .package(name: "SPLogger", path: "../SPLogger")
    ],
    targets: [
        .target(
            name: "SPWebParser",
            dependencies: [
                "SwiftSoup",
                "SPError",
                "SPLogger"
            ],
            resources: [.process("Resources")],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        ),
        .testTarget(
            name: "SPWebParserTests",
            dependencies: ["SPWebParser"],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        )
    ]
)
