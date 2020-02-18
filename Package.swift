// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pixtools",
    platforms: [
        .macOS(.v10_12)
    ],
    dependencies: [
//        .package(url: "https://github.com/hexagons/LiveValues.git", from: "1.1.7"),
//        .package(url: "https://github.com/hexagons/RenderKit.git", from: "0.3.3"),
//        .package(url: "https://github.com/hexagons/PixelKit.git", from: "0.9.5"),
        .package(path: "~/Code/Frameworks/Production/LiveValues"),
        .package(path: "~/Code/Frameworks/Production/RenderKit"),
        .package(path: "~/Code/Frameworks/Production/PixelKit"),
    ],
    targets: [
        .target(name: "pixtools", dependencies: ["LiveValues", "RenderKit", "PixelKit"])
    ]
)
