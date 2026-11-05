#!/bin/bash
set -euo pipefail

project_root="$(cd "$(dirname "$0")/../.." && pwd)"
build_root="${project_root}/ios/.build"
mkdir -p "${build_root}/module-cache"
export CLANG_MODULE_CACHE_PATH="${build_root}/module-cache"
export SWIFTPM_MODULECACHE_OVERRIDE="${build_root}/module-cache"

if [[ -d "${build_root}/Metal.xctoolchain" ]]; then
    toolchain_id="$(/usr/libexec/PlistBuddy -c 'Print :Identifier' "${build_root}/Metal.xctoolchain/ToolchainInfo.plist")"
    export EXTERNAL_TOOLCHAINS_DIR="${build_root}"
    export TOOLCHAINS="${toolchain_id} com.apple.dt.toolchain.XcodeDefault"
fi

if [[ "${1:-}" == "xcode" ]]; then
    exec /usr/bin/open -n -a Xcode \
        --env "EXTERNAL_TOOLCHAINS_DIR=${EXTERNAL_TOOLCHAINS_DIR:-}" \
        --env "TOOLCHAINS=${TOOLCHAINS:-com.apple.dt.toolchain.XcodeDefault}" \
        --env "CLANG_MODULE_CACHE_PATH=${CLANG_MODULE_CACHE_PATH}" \
        --env "SWIFTPM_MODULECACHE_OVERRIDE=${SWIFTPM_MODULECACHE_OVERRIDE}" \
        "${project_root}/ios/FirstStepToCareer.xcodeproj"
fi

if [[ $# -eq 0 ]]; then
    echo '실행할 명령을 지정하세요. Xcode 열기: bash ios/Scripts/project-env.sh xcode' >&2
    exit 1
fi
exec "$@"
