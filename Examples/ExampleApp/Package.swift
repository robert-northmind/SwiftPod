// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ExampleApp",
    dependencies: [
        .package(path: "../../../SwiftiePod")
    ],
    targets: [
        .executableTarget(
            name: "ExampleApp",
            dependencies: [.product(name: "SwiftiePod", package: "SwiftiePod")],
            path: "Sources/"
        ),
    ]
)
