// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pixtools",
    platforms: [
        .macOS(.v10_12)
    ],
    dependencies: [
        .package(path: "../../../Frameworks/Production/LiveValues"),
        .package(path: "../../../Frameworks/Production/RenderKit"),
        .package(path: "../../../Frameworks/Production/PixelKit"),
    ],
    targets: [
        .target(name: "pixtools", dependencies: ["LiveValues", "RenderKit", "PixelKit"])
    ]
)
