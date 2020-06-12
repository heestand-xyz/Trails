// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Trails",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Trails", targets: ["Trails"]),
    ],
    targets: [
        .target(name: "Trails"),
    ]
)
