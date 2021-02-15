// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FRBKit",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .library(
            name: "FRBKit",
            targets: ["FRBKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/CombineExpectations", from: "0.7.0")    
    ],
    targets: [
        .target(
            name: "FRBKit",
            dependencies: []),
        .testTarget(
            name: "FRBKitTests",
            dependencies: ["FRBKit", "CombineExpectations"]),
    ]
)
