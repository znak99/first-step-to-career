// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "LocalLLMRuntime",
    platforms: [.iOS(.v26), .macOS(.v14)],
    products: [
        .library(name: "LocalLLMRuntime", targets: ["LocalLLMRuntime"]),
        .executable(name: "LLMSmoke", targets: ["LLMSmoke"])
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlx-swift-lm", exact: "3.32.3", traits: []),
        .package(url: "https://github.com/ml-explore/mlx-swift", exact: "0.32.3"),
        .package(url: "https://github.com/huggingface/swift-transformers", exact: "1.4.0")
    ],
    targets: [
        .target(name: "LocalLLMRuntime", dependencies: [
            .product(name: "MLXLLM", package: "mlx-swift-lm"),
            .product(name: "MLXLMCommon", package: "mlx-swift-lm"),
            .product(name: "MLX", package: "mlx-swift"),
            .product(name: "Tokenizers", package: "swift-transformers")
        ]),
        .executableTarget(name: "LLMSmoke", dependencies: ["LocalLLMRuntime"]),
        .testTarget(name: "LocalLLMRuntimeTests", dependencies: ["LocalLLMRuntime"])
    ]
)
