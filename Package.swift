// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RepresentableKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "RepresentableKit",
            targets: ["RepresentableKit"]
        ),
    ],
    targets: [
        .target(
            name: "RepresentableKit"
        )
    ]
)
