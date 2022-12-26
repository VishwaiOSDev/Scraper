// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scraper",
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3")
    ],
    targets: [
        .executableTarget(
            name: "Scraper",
            dependencies: ["SwiftSoup"]
        ),
        .testTarget(name: "ScraperTests", dependencies: ["Scraper"]),
    ]
)
