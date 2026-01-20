// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StitchVision",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "StitchVision",
            targets: ["StitchVision"]
        ),
    ],
    dependencies: [
        // Add future dependencies here
        // Example: Camera and Vision frameworks will be added later
    ],
    targets: [
        .target(
            name: "StitchVision",
            dependencies: []
        ),
        .testTarget(
            name: "StitchVisionTests",
            dependencies: ["StitchVision"]
        ),
    ]
)