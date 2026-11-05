#!/bin/bash
set -euo pipefail

staging_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
verification_root="$(mktemp -d "${TMPDIR:-/tmp}/first-step-core.XXXXXX")"
printf '검증용 임시 경로: %s\n' "$verification_root"

mkdir -p "$verification_root/Sources/FirstStepToCareer" "$verification_root/Tests/FirstStepToCareerTests" "$verification_root/cache"
cp -R "$staging_root/Sources/Core/." "$verification_root/Sources/FirstStepToCareer/"
cp -R "$staging_root/Tests/Core/." "$verification_root/Tests/FirstStepToCareerTests/"

cat > "$verification_root/Package.swift" <<'SWIFT'
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FirstStepToCareerVerification",
    platforms: [.macOS(.v14)],
    targets: [
        .target(name: "FirstStepToCareer"),
        .testTarget(name: "FirstStepToCareerTests", dependencies: ["FirstStepToCareer"])
    ],
    swiftLanguageModes: [.v6]
)
SWIFT

xcrun swiftc -swift-version 6 -parse-as-library -typecheck \
    -module-name FirstStepToCareer \
    -sdk "$(xcrun --sdk iphoneos --show-sdk-path)" \
    -target arm64-apple-ios26.0 -module-cache-path "$verification_root/cache" \
    "$staging_root"/Sources/Core/*.swift

cat > "$verification_root/cache/IsolationProbe.swift" <<'SWIFT'
nonisolated func verifyCoreIsolation() throws {
    let configuration = try InterviewConfiguration()
    _ = try AnswerScoring.average(completedQuestions: [])
    _ = try OverallScoring.calculate(configuration: configuration, completedQuestions: [], movement: nil, termination: .newQuestionNonresponse)
    var movement = MovementScoring()
    movement.recordCheck(gaze: nil, head: nil)
}
SWIFT

xcrun swiftc -swift-version 6 -default-isolation MainActor -parse-as-library -typecheck \
    -module-name FirstStepToCareer \
    -sdk "$(xcrun --sdk iphoneos --show-sdk-path)" \
    -target arm64-apple-ios26.0 -module-cache-path "$verification_root/cache" \
    "$staging_root"/Sources/Core/*.swift "$verification_root/cache/IsolationProbe.swift"

CLANG_MODULE_CACHE_PATH="$verification_root/cache" \
    xcrun swift test --package-path "$verification_root" \
    --cache-path "$verification_root/cache" --disable-sandbox "$@"
