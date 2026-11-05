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
