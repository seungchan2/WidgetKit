// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BaseDependency",
    platforms: [
         // Specify the minimum version of iOS required.
         .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BaseDependency",
            targets: ["BaseDependency"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "./RxSwiftModule"),
        .package(path: "./CombineModule")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BaseDependency",
            dependencies: [
                .product(name: "RxSwiftModule", package: "RxSwiftModule"),
                .product(name: "CombineModule", package: "CombineModule")
        ]),
        .testTarget(
            name: "BaseDependencyTests",
            dependencies: ["BaseDependency"]),
    ]
)
