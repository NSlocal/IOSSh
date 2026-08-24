// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "UniversalGames",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "UniversalGames",
            targets: ["UniversalGames"]
        ),
        .library(
            name: "UniversalGamesDynamic",
            type: .dynamic,
            targets: ["UniversalGames"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "UniversalGames",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                "Alamofire",
                "SwiftyJSON"
            ],
            path: "src/UniversalGames/Sources/UniversalGames",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "UniversalGamesTests",
            dependencies: ["UniversalGames"],
            path: "src/UniversalGames/Tests/UniversalGamesTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
