// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "RxCocoaNetworking",
    products: [
        .library(
            name: "RxCocoaNetworking",
            targets: ["RxCocoaNetworking"]),
        ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.1.0")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "7.1.0"))
        ],
    targets: [
        .target(
            name: "RxCocoaNetworking",
            dependencies: ["RxCocoa", "RxSwift"],
            path: "Sources"),
        .testTarget(
            name: "RxCocoaNetworkingTests",
            dependencies: ["RxCocoaNetworking", "RxCocoa", "RxSwift", "RxTest", "Quick", "Nimble"],
            path: "Tests")
    ]
)
