// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ReaderToolbarPrimitive",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "ReaderToolbarPrimitive",
            targets: ["ReaderToolbarPrimitive"]
        ),
    ],
    dependencies: [
        .package(path: "../ReaderChromeThemePrimitive"),
        .package(path: "../ReaderSidebarPrimitive"),
    ],
    targets: [
        .target(
            name: "ReaderToolbarPrimitive",
            dependencies: [
                .product(name: "ReaderChromeThemePrimitive", package: "ReaderChromeThemePrimitive"),
                .product(name: "ReaderSidebarPrimitive", package: "ReaderSidebarPrimitive"),
            ]
        ),
        .testTarget(
            name: "ReaderToolbarPrimitiveTests",
            dependencies: ["ReaderToolbarPrimitive"]
        ),
    ]
)
