# Local model files

The user requested a local copy of the approved first validation model, `LiquidAI/LFM2.5-1.2B-JP-202606`.

- Source: [official model repository](https://huggingface.co/LiquidAI/LFM2.5-1.2B-JP-202606).
- Pinned revision: `52b8b4475311a63bf839c6494f78f8ad59d13515`.
- Local destination: `llm/LFM2.5-1.2B-JP-202606/`.
- Download: all 10 files in the official repository, including the original BF16 Safetensors weights, configuration, tokenizer, chat template, model card, and license.
- Expected total size: 2,345,557,023 bytes (about 2.35 GB); weights: 2,340,697,936 bytes.
- Status: all 10 files downloaded and verified on 2026-11-05. Total local file size: 2,345,557,023 bytes.
- Integrity: the weights' SHA-256 and the smaller files' Git blob SHA-1 values match official metadata. JSON files parse successfully. The Safetensors header and all tensor data ranges are consistent: 148 BF16 tensors, 1,170,340,608 parameters. File checksums and verification time are recorded in the manifest.
- Git: the local model directory is ignored. Only this guide, the provenance manifest, and project documentation are committed. A clone of this repository does not include the model weights.

Downloading the original files does not select a production precision or approve a quantized variant, install MLX Swift LM, load the model, or validate iPhone compatibility or grading quality. Those decisions remain separate. The original source license is retained without modification.

Download status and verification results: [manifest](LFM2.5-1.2B-JP-202606.manifest.json). Operational details are recorded in [OPERATIONS.md](../docs/system-design/OPERATIONS.md).

Version and format research is recorded in [MLX_RESEARCH.md](../docs/system-design/MLX_RESEARCH.md). The proposed combination is MLX Swift LM 3.32.3, swift-transformers 1.4.0, and the official MLX 4-bit variant (696,868,510 bytes across 10 files). This is pending approval. Only the candidate's metadata and small configuration documents were inspected; its weights were not downloaded, and no runtime packages were installed or models executed. Keep the original and any future approved variant in separate directories.

## 개발용 시험 연결

사용자가 기존 BF16 원본으로 시험하는 MLX Swift LM 3.32.3·mlx-swift 0.32.3·swift-transformers 1.4.0 연결을 승인했다. 추가 모델 다운로드·정밀도 변환은 하지 않는다. 의존성과 빌드 결과는 `ios/.build/` 아래에서 관리하며 패키지를 전역 설치하지 않는다. Debug 실기기 빌드만 원본을 앱의 `LocalLLM` 리소스에 복사한다. Release·시뮬레이터는 모델을 제외하고 시뮬레이터에는 실행 제한을 표시한다.

같은 연결 소스로 Mac에서 일본어 `こんにちは。` 생성·출력 도중 취소·취소 후 `ありがとう。` 재생성을 확인했다. 이는 iPhone 지원·속도·메모리·발열 또는 면접 답변 품질 검증을 대신하지 않는다. 실행 방법과 Metal 도구의 프로젝트 내부 사용 방식은 [OPERATIONS.md](../docs/system-design/OPERATIONS.md#개발용-llm-빌드실행-2026-11-05)를 따른다.
