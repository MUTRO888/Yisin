// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Yisin",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "Yisin",
            targets: ["Yisin"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Yisin",
            path: "Yisin/Sources",
            resources: [
                .process("../Resources"),
                .process("../Assets.xcassets")
            ]
        )
    ]
)
