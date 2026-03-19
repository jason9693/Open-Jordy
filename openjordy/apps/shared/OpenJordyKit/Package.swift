// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "OpenJordyKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "OpenJordyProtocol", targets: ["OpenJordyProtocol"]),
        .library(name: "OpenJordyKit", targets: ["OpenJordyKit"]),
        .library(name: "OpenJordyChatUI", targets: ["OpenJordyChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "OpenJordyProtocol",
            path: "Sources/OpenJordyProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenJordyKit",
            dependencies: [
                "OpenJordyProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/OpenJordyKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenJordyChatUI",
            dependencies: [
                "OpenJordyKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/OpenJordyChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "OpenJordyKitTests",
            dependencies: ["OpenJordyKit", "OpenJordyChatUI"],
            path: "Tests/OpenJordyKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
