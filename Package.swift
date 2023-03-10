// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scraper",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
        .package(url: "git@github.com:VishwaiOSDev/NetworkKit.git", from: "0.1.2"),
        .package(url: "git@github.com:VishwaiOSDev/LogKit.git", from: "0.0.11")
    ],
    targets: [
        .executableTarget(
            name: "Scraper",
            dependencies: [
                "SwiftSoup",
                "NetworkKit",
                "LogKit"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "ScraperTests", dependencies: ["Scraper"]),
    ]
)
