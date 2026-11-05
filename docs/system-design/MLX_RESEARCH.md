# MLX Swift LM 버전·모델 파일 형식 조사

조사일: 2026-11-05. 이후 사용자가 개발용 LLM 시험 화면과 기존 BF16 원본 모델의 MLX 연결을 승인했다. MLX Swift LM 3.32.3·내부 mlx-swift 0.32.3·swift-transformers 1.4.0을 프로젝트 의존성으로 추가하며 전역 설치는 금지한다. 아래 4비트 모델 채택·추가 다운로드는 여전히 미승인 제안이다. 이전 조사 시점의 미수행 기록과 현재 연결 작업은 구분한다.

## 1. 제안

첫 실행 시험에는 **MLX Swift LM 3.32.3 + 제작사 공식 MLX 4비트 모델**을 제안한다. 글을 모델의 숫자 입력으로 바꾸는 도구인 토크나이저는 **swift-transformers 1.4.0의 Tokenizers**를 제안한다. 기존 BF16 원본은 비교용으로 보존한다. 제품 최종 채택·iPhone 13 지원·일본어 면접 평가 품질은 실제 시험 후 판단한다.

| 대상 | 고정 제안 | 상태 |
|---|---|---|
| 모델 실행 도구 | `mlx-swift-lm` 정확히 `3.32.3` | 조사 완료, 채택 미승인 |
| 내부 계산 도구 | `mlx-swift` `0.32.3` | 함께 고정 제안, 실제 의존성 해결 미실시 |
| 글자 변환 도구 | `swift-transformers` 정확히 `1.4.0`, 제품 `Tokenizers` | 새 의존성이므로 승인 필요 |
| 모델 | `LiquidAI/LFM2.5-1.2B-JP-202606-MLX-4bit` | 설정·파일 목록만 확인, 가중치 미다운로드 |
| 최소 OS | 승인된 iOS 26.0 유지 | 지원 성공을 뜻하지 않음 |
| 첫 연결 방식 | 로컬 모델 폴더 + 토크나이저 연결 코드 | 구현·패키지 추가 미실시 |

SwiftUI는 화면을 구성하는 도구다. 모델 파일을 SwiftUI에 넣는 것만으로 실행되지 않으며, MLX로 읽고 생성 결과를 화면에 전달하는 연결 코드가 필요하다.

## 2. 실행 도구 버전 비교

| MLX Swift LM | 확인한 배포일 | 주요 조건 | 검토 결과 |
|---|---|---|---|
| `3.32.3` | 2026-09-30 | 패키지 자체 Swift 6.2, iOS 17 이상 선언. 내부 `mlx-swift` 허용 범위 `0.32.3..<0.33.0` | 조사 시 최신 정식 릴리스이며 첫 검증 후보 |
| `3.31.4` | 2026-06-30 | 패키지 자체 Swift 6.1, iOS 17 이상 선언. 내부 `mlx-swift` `0.31.4..<0.32.0` | 이전 비교 후보. 자동 대체하지 않음 |
| `2.31.3` | 2026-04-01 | 3.x와 연결 API가 다름 | 기존 2.x 예제를 새 코드에 그대로 적용하지 않음 |

버전·배포일은 [공식 릴리스](https://github.com/ml-explore/mlx-swift-lm/releases), 조건은 [3.32.3 패키지](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Package.swift)와 [3.31.4 패키지](https://github.com/ml-explore/mlx-swift-lm/blob/3.31.4/Package.swift)에서 확인했다. `3.32.3` 태그의 커밋은 `3b339ad6e3b3f44c8121ecff5131c7fd55e075e6`이다. 계속 바뀌는 `main`을 버전 기준으로 삼지 않는 안을 제안한다.

내부 의존성까지 보면 `mlx-swift 0.32.3`은 Swift 6.3 도구와 `experimentalCGen` 선언을 사용한다. 따라서 MLX Swift LM 파일의 Swift 6.2 선언만으로 전체 빌드 도구 하한을 설명하면 안 된다. 현재 Mac의 Xcode 27.2·Swift 6.4.2는 선언된 버전보다 새롭지만, 패키지 해결·컴파일을 수행하지 않았으므로 빌드 성공은 미확인이다. [내부 패키지 정의](https://github.com/ml-explore/mlx-swift/blob/0.32.3/Package.swift)

`3.32.3`에는 Apple FoundationModels 연결 기능을 켜는 기본 옵션 `FoundationModelsIntegration`이 있다. 이 별도 연결 기능은 iOS 27 API를 요구한다. iOS 26 검증에서는 이를 끄고 `MLXLLM`·`MLXLMCommon`만 사용하는 안을 제안한다. 최소 OS를 27로 올리거나 이 기능을 추가로 채택하는 결정은 하지 않는다. 실제 Xcode 설정 방법·빌드 결과는 후속 검증 대상이다. [옵션 설명](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Package.swift)

## 3. 모델 파일 비교

Safetensors는 모델이 학습한 숫자인 가중치를 담는 파일 형식이다. 같은 확장자여도 숫자 표현과 내부 배치가 다를 수 있다. 양자화는 숫자 정밀도를 낮춰 용량을 줄이는 방식이며, 이번 4비트 파일도 Safetensors 형식이다.

| 항목 | 이미 보관한 제작사 원본 | 추가 검증 후보 |
|---|---|---|
| 저장소 | `LiquidAI/LFM2.5-1.2B-JP-202606` | `LiquidAI/LFM2.5-1.2B-JP-202606-MLX-4bit` |
| 고정 리비전 | `52b8b4475311a63bf839c6494f78f8ad59d13515` | `90aac12667f814fb003a2ced67572af1c2a3c8f4` |
| 가중치 표현 | BF16, 숫자당 16비트 | MLX용 주로 4비트, 일부 6비트 |
| 가중치 파일 | `model.safetensors` | `model.safetensors` |
| 가중치 크기 | 2,340,697,936바이트 | 692,094,682바이트 |
| 공개 파일 10개 전체 | 2,345,557,023바이트, 약 2.35GB | 696,868,510바이트, 약 696.9MB |
| 확인 수준 | 실제 파일·해시·148개 BF16 텐서 검증 | 공식 파일 목록·설정·색인 확인만 수행 |

용량은 십진 단위다. 원본의 실제 검증 기록은 [로컬 보관 manifest](../../llm/LFM2.5-1.2B-JP-202606.manifest.json), 후보 크기는 [고정 리비전 공식 파일 메타데이터](https://huggingface.co/api/models/LiquidAI/LFM2.5-1.2B-JP-202606-MLX-4bit/revision/90aac12667f814fb003a2ced67572af1c2a3c8f4?blobs=true)를 기준으로 합산했다. 작은 파일은 조사용으로 임시 폴더에서 읽었고 후보 가중치는 받지 않았다.

제작사 설명과 후보 `config.json`은 기본 4비트·64개 숫자 단위 묶음·`affine` 방식을 사용하고, 입출력에 공유되는 `model.embed_tokens`에는 6비트를 적용한다. 따라서 전부 4비트인 파일로 설명하거나 임의로 다시 변환하지 않는다. [제작사 설명](https://huggingface.co/LiquidAI/LFM2.5-1.2B-JP-202606-MLX-4bit), [고정 설정](https://huggingface.co/LiquidAI/LFM2.5-1.2B-JP-202606-MLX-4bit/blob/90aac12667f814fb003a2ced67572af1c2a3c8f4/config.json)

추가 다운로드를 승인받으면 위 리비전의 파일 묶음 전체를 별도 `llm/LFM2.5-1.2B-JP-202606-MLX-4bit/`에 보관하는 안을 제안한다. 가중치의 공식 SHA-256 기대값은 `de9888258a0638d8f330bdf9df2c1c9516b179d2b75edf2a7c9bd481b8c666ee`다. 이는 메타데이터에서 확인한 값이며 로컬 후보 가중치와 대조한 결과는 아니다.

파일 크기는 실행 중 메모리 사용량이 아니다. 모델 외에도 계산용 자료·이전 문맥·화면·음성·카메라가 메모리를 사용하므로, 697MB라는 값으로 기기 동작이나 원본과 동일한 답변 품질을 보장하지 않는다.

## 4. Swift 연결 호환성 조사

아래는 소스를 읽어 판단한 **정적 호환성 근거**다. 실제 모델 읽기·출력 시험을 대신하지 않는다.

| 확인 항목 | 확인한 근거 | 남은 검증 |
|---|---|---|
| 모델 구조 | 후보 `model_type=lfm2`; 3.32.3 공장에서 `lfm2`를 LFM2 구현으로 연결 | 전체 가중치 이름·형상·값 읽기 |
| 구성 설정 | LFM2 구현이 `layer_types`·`rope_parameters`를 읽음 | 실제 일본어 생성 결과 |
| 혼합 정밀도 | 공통 설정·읽기 코드가 계층별 양자화 설정을 처리 | 4/6비트 실제 계산·기기 지원 |
| 가중치 색인 | 후보 색인의 모든 항목이 공개 목록에 있는 `model.safetensors`를 가리킴 | 실제 파일과 색인의 일치 |
| 글자 변환 | 원본·후보 `tokenizer.json`의 공식 Git blob 값이 같음 | 일본어·기호·줄바꿈·특수 토큰 왕복 |
| 대화 형식 | 원본·후보 `chat_template.jinja`의 공식 Git blob 값이 같음 | 별도 템플릿 파일 읽기·질문/답변 역할·종료 토큰 적용 |

구조 근거: [모델 공장](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Libraries/MLXLLM/LLMModelFactory.swift), [LFM2 구현](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Libraries/MLXLLM/Models/LFM2.swift), [양자화 설정](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Libraries/MLXLMCommon/BaseConfiguration.swift), [파일 읽기](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Libraries/MLXLMCommon/Load.swift). 파일 동일성·색인은 원본 manifest와 위 후보 공식 메타데이터·고정 리비전의 색인 JSON을 대조했다.

토크나이저 설정 파일은 서로 다르다. 원본의 클래스 이름은 `PreTrainedTokenizerFast`, 후보는 `TokenizersBackend`다. `swift-transformers 1.4.0`은 두 이름을 BPE 구현으로 연결하는 코드를 포함한다. 파일 이름이 같다고 두 모델 폴더의 설정을 섞지 않는다. 기본 엄격 검증을 끄거나 제작사 설정을 고치는 우회안은 제안하지 않는다. [토크나이저 구현](https://github.com/huggingface/swift-transformers/blob/1.4.0/Sources/Tokenizers/Tokenizer.swift)

## 5. 추가 의존성과 연결 범위 제안

3.x는 실제 토크나이저 구현을 외부에서 연결한다. `Tokenizer`·`TokenizerLoader`라는 연결 규약을 구현해야 하며, 로컬 파일만 읽는 첫 시험에는 별도 다운로드 연결부가 필수는 아니다. `MLXHuggingFace` 매크로를 쓰는 다른 방법도 있지만, 첫 로컬 시험에는 직접 토크나이저 연결 코드를 작성하는 안을 제안한다. [3.32.3 사용 안내](https://github.com/ml-explore/mlx-swift-lm/blob/3.32.3/Libraries/MLXLMCommon/Documentation.docc/using.md)

`swift-transformers 1.4.0`은 2026-11-02 공개된 최신 정식 버전이며 디코딩 공백 처리와 잘못된 정규식 오류 처리 등이 바뀌었다. 모델 설정의 공백 정리 값은 원본·후보 모두 거짓이다. 이를 포함해 실제 입력·출력 비교는 필요하다. [공식 릴리스](https://github.com/huggingface/swift-transformers/releases/tag/1.4.0)

`Tokenizers`만 선택해도 내부적으로 `Hub`·`swift-jinja`·`swift-huggingface`·`swift-collections`·`swift-crypto`·`yyjson` 등의 의존성이 연결된다. MLX 쪽에도 `mlx-swift`·`swift-syntax`·`swift-numerics` 등이 있다. 로컬 읽기 방식을 선택해도 외부 패키지가 없어지는 것은 아니다. 실제 선택 버전 전체는 승인 후 의존성을 해결하고 `Package.resolved`에 기록해야 한다. 이번 조사에서는 패키지를 받거나 해결하지 않았다. [토크나이저 패키지 정의](https://github.com/huggingface/swift-transformers/blob/1.4.0/Package.swift), [MLX 내부 패키지 정의](https://github.com/ml-explore/mlx-swift/blob/0.32.3/Package.swift)

## 6. 승인 후 제안하는 작업 순서

1. 위 실행/계산/토크나이저 버전·iOS 26용 옵션·추가 4비트 모델 채택과 다운로드 범위를 승인받는다.
2. 후보 모델을 별도 폴더에 받아 공식 해시·JSON·Safetensors/색인을 검사하고 Git에서 가중치를 제외한다. 원본은 보존한다.
3. `ios_temp/`에 옮겨 쓸 연결 소스와 별도 시험 자료를 작성하고, 사용자 Xcode 프로젝트의 앱/시험 대상에 나누어 연결한다. 프로젝트 자동 생성·기존 프로젝트 덮어쓰기는 하지 않는다.
4. 로컬 읽기·공식 대화 템플릿·일본어 생성·종료 토큰·취소 후 이전 결과 차단을 먼저 시험한다. 실제 면접 질문/평가 지시문과 점수 출력 형식은 별도 승인받는다.
5. 보유 iPhone 14 Plus의 iOS 26 이상 여부를 확인한 뒤 읽기 시간·첫 출력까지 시간·응답 속도·최대 메모리·발열을 측정한다. 이후 음성·카메라와 함께 3/5/7문 전체 흐름을 검증한다. iPhone 13은 별도 실기기 검증이 필요하다.

시험용 문장·문맥/출력 길이·생성 설정·질문 생성 및 채점 품질 자료·속도/메모리/발열 합격 기준은 미정이다. 해당 수치를 임의로 확정하지 않는다. 배포 시 모델을 앱에 포함할지 내려받게 할지, 서버 사용·외부 전송·라이선스에 따른 제품 배포 절차도 이번 조사에서 결정하지 않는다.

## 7. 수행한 것과 수행하지 않은 것

- 수행: 공식 릴리스·버전별 패키지/모델 읽기 코드·후보 파일 목록/설정/색인 조사, 원본 manifest와 글자 변환 파일·템플릿 식별값 대조, 호환성 근거와 미검증 항목 정리.
- 미수행: 패키지 설치/해결/컴파일, 후보 가중치 다운로드·변환, 원본/후보 모델 실행, 실제 iOS 앱·실기기·품질/성능 시험.
- 기존 Core의 48개 시험 통과는 면접 진행·점수 규칙 검증이다. MLX 호환성이나 AI 평가 품질의 검증 결과로 사용하지 않는다.

## 개발용 연결 승인과 작업 상태 (2026-11-05)

- 승인: 면접 화면의 Debug 전용 버튼·LLM 시험 화면, 위 실행/토크나이저 패키지와 기존 `llm/LFM2.5-1.2B-JP-202606/` 원본 사용. 컴퓨터 전역 설치는 하지 않는다.
- 패키지 체크아웃·캐시·빌드 결과는 Git에서 제외한 `ios/.build/` 아래에서 관리한다. 앱의 직접 의존성과 독립 검증용 `ios/Packages/LocalLLMRuntime/Package.swift`는 같은 버전을 사용한다. 실제 간접 의존성은 Xcode가 생성한 앱의 `Package.resolved`와 독립 검증 패키지의 `Package.resolved`에 기록했다. 두 파일의 12개 간접/직접 의존성 버전·커밋이 동일함을 대조했다.
- 원본 모델과 공식 `chat_template.jinja`를 읽는 연결을 작성했다. 추가 모델 다운로드·정밀도 변환은 하지 않는다. 시험용 생성 상한 256토큰·temperature 0.1·topK 50·반복 보정 1.05는 면접 채점 정책과 구분한다.
- 프로젝트 내부 `ios/.build/Metal.xctoolchain`을 외부 도구 경로로 지정해 빌드했다. 전역 설치·등록은 하지 않았으며 Apple 내보내기 명령의 시스템 다운로드 캐시는 남아 있다. Mac에서 실제 일본어 생성·생성 도중 취소·취소 후 재생성을 확인했고 오류/취소 단위 시험 3개도 통과했다. iPhone 실행·성능·품질은 미검증이다.
