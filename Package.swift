// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Trails",
    platforms: [
        .iOS(.v13),
//        .tvOS(.v13),
//        .watchOS(.v6),
//        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Trails", targets: ["Trails"]),
    ],
    targets: [
        .target(name: "Trails"),
    ]
)
