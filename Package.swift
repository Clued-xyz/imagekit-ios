// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "imagekit-ios",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ImageKitIO",
            targets: ["ImageKitIO"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ImageKitIO",
            dependencies: []
        ),
    ]
)
