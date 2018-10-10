// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sbg",
    dependencies: [
        .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMinor(from: "0.13.0")),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from:"7.3.1")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "1.3.2"))
    ],
    targets: [
        .target(
            name: "SBG",
            dependencies: ["SBGCore"]),
        .target(
            name: "SBGCore",
            dependencies: ["Stencil", "xcodeproj"]),
        .testTarget(
            name: "SBGTests",
            dependencies: ["SBGCore", "Quick", "Nimble"]),
    ]
)
