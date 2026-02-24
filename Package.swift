// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AdOrNot",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    targets: [
        .executableTarget(
            name: "AdOrNot",
            path: "Sources/AdOrNot",
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "AdOrNotTests",
            dependencies: ["AdOrNot"],
            path: "Tests/AdOrNotTests"
        ),
    ],
    swiftLanguageModes: [.v5]
)
