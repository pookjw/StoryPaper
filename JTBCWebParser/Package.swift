// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JtbcWebParser",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "JtbcWebParser",
            targets: ["JtbcWebParser"])
    ],
    dependencies: [
        .package(name: "SPWebParser", path: "../SPWebParser")
    ],
    targets: [
        .target(
            name: "JtbcWebParser",
            dependencies: ["SPWebParser"],
            resources: [.process("Resources")],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        ),
        .testTarget(
            name: "JtbcWebParserTests",
            dependencies: ["JtbcWebParser"],
            swiftSettings: [
                .unsafeFlags(["-strict-concurrency=complete"])
            ]
        )
    ]
)
