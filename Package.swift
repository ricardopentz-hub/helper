// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HelperApp",
    platforms: [
        // Target iOS 27.0 as requested. If your Xcode doesn't support v27 yet, change this to a lower SDK.
        .iOS("27.0")
    ],
    products: [
        .library(name: "HelperApp", targets: ["HelperApp"]),
    ],
    targets: [
        .target(
            name: "HelperApp",
            path: "Sources/HelperApp"
        ),
        .testTarget(
            name: "HelperAppTests",
            dependencies: ["HelperApp"],
            path: "Tests/HelperAppTests"
        )
    ]
)
