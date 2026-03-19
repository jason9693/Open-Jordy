// swift-tools-version: 6.2
// Package manifest for the OpenJordy macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "OpenJordy",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "OpenJordyIPC", targets: ["OpenJordyIPC"]),
        .library(name: "OpenJordyDiscovery", targets: ["OpenJordyDiscovery"]),
        .executable(name: "OpenJordy", targets: ["OpenJordy"]),
        .executable(name: "openjordy-mac", targets: ["OpenJordyMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/OpenJordyKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "OpenJordyIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "OpenJordyDiscovery",
            dependencies: [
                .product(name: "OpenJordyKit", package: "OpenJordyKit"),
            ],
            path: "Sources/OpenJordyDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "OpenJordy",
            dependencies: [
                "OpenJordyIPC",
                "OpenJordyDiscovery",
                .product(name: "OpenJordyKit", package: "OpenJordyKit"),
                .product(name: "OpenJordyChatUI", package: "OpenJordyKit"),
                .product(name: "OpenJordyProtocol", package: "OpenJordyKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/OpenJordy.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "OpenJordyMacCLI",
            dependencies: [
                "OpenJordyDiscovery",
                .product(name: "OpenJordyKit", package: "OpenJordyKit"),
                .product(name: "OpenJordyProtocol", package: "OpenJordyKit"),
            ],
            path: "Sources/OpenJordyMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "OpenJordyIPCTests",
            dependencies: [
                "OpenJordyIPC",
                "OpenJordy",
                "OpenJordyDiscovery",
                .product(name: "OpenJordyProtocol", package: "OpenJordyKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
