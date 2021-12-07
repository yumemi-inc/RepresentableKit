// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PreviewKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PreviewKit",
            targets: ["PreviewKit"]
        ),
    ],
    targets: [
        .target(
            name: "PreviewKit"
        )
    ]
)
