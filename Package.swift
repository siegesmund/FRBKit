// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Fred",
    products: [
        .library(
            name: "Fred",
            targets: ["Fred"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Fred",
            dependencies: []),
        .testTarget(
            name: "FredTests",
            dependencies: ["Fred"]),
    ]
)
