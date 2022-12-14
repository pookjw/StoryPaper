// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPError",
    defaultLocalization: "en",
    products: [
        .library(
            name: "SPError",
            targets: ["SPError"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SPError",
            dependencies: [],
            resources: [.process("Resources")]
        ),
    ]
)
