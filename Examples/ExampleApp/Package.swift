// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ExampleApp",
    dependencies: [
        .package(path: "../../../SwiftPod")
    ],
    targets: [
        .executableTarget(
            name: "ExampleApp",
            dependencies: [.product(name: "SwiftPod", package: "SwiftPod")]
        ),
    ]
)
