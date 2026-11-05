#!/bin/bash
set -euo pipefail

if [[ "${CONFIGURATION}" != "Debug" || "${PLATFORM_NAME}" == "iphonesimulator" ]]; then
    exit 0
fi

model_source="${SRCROOT}/../llm/LFM2.5-1.2B-JP-202606"
model_destination="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/LocalLLM"
if [[ ! -f "${model_source}/model.safetensors" ]]; then
    echo 'error: llm/LFM2.5-1.2B-JP-202606/model.safetensors が見つかりません。'
    exit 1
fi
mkdir -p "${model_destination}"
for name in LICENSE README.md chat_template.jinja config.json generation_config.json \
    model.safetensors special_tokens_map.json tokenizer.json tokenizer_config.json; do
    /bin/cp -p "${model_source}/${name}" "${model_destination}/${name}"
done
