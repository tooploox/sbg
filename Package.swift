// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sbg",
    dependencies: [
        .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMinor(from: "0.13.0")),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "sbg",
            dependencies: ["Stencil", "xcodeproj"]),
        .testTarget(
            name: "sbgTests",
            dependencies: ["sbg"]),
    ]
)
