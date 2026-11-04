# 就活一歩

혼자서 면접을 연습하고 취업활동을 관리하기 위한 앱

## Project Status
- Scale: small; work directly on `main`.
- Platform: iOS only.
- Implementation language: Swift (approved).
- User interface: SwiftUI (approved).
- Testing: Swift Testing for unit/integration tests, XCTest + XCUIAutomation for UI automation, and XCTest for performance measurement (approved); test structure and acceptance criteria remain undecided.
- Minimum iOS version: 26.0 (approved).
- Target devices: iPhone 13 and later if feasible; final support depends on device and performance validation.
- First validation LLM: LFM2.5-1.2B-JP-202606, approved for evaluation; production adoption remains undecided.
- Validation runtime: MLX Swift LM, approved; package version and integration settings remain undecided.
- Speech-to-text: Apple SpeechAnalyzer + SpeechTranscriber, approved for on-device recognition; device and Japanese-language support require validation.
- Text-to-speech: Apple AVSpeechSynthesizer, approved; voice, speaking rate, and playback validation remain pending.
- Gaze and head movement: Apple ARKit, approved; calibration, distance criteria, tracking accuracy, and scoring thresholds require validation and approval.
- Local persistence: SwiftData with CloudKit automatic sync disabled, approved; schema and remaining storage policies remain undecided.
- UI language: Japanese (`ja`).
- Release market: Japan only.
- Server: undecided; prefer avoiding a server where feasible.
- Remaining application stack and data model: undecided, pending user approval.
- Project documentation includes the user-confirmed mock interview requirements. The iOS application project has not been created yet.

## Features
- AI-led mock interviews configured by company name, industry, job role, and interview type (HR or job-specific).
- A question count that defaults to 5 on first use and is adjustable from 3 to 7 through settings or a similar menu.
- A preparation screen checks the distance needed to observe gaze and head movement. If the front camera does not work or the device lacks TrueDepth support, both movement categories are excluded from scoring and the overall score.
- Questions are read aloud through text-to-speech (TTS). During the user's turn, speech-to-text (STT) displays the answer.
- After question playback or a continue-speaking request, wait without automatic completion until STT detects at least one word from the new speech. This is the definition of starting to speak, including when resuming an answer.
- After the answer starts, 3 seconds of silence indicate completion, with an animated countdown showing the time remaining. The continue-speaking button remains available while the LLM prepares or TTS reads the next question. Pressing it stops preparation/playback and resumes the previous answer; after the user finishes, the LLM reconsiders the next question using the full answer.
- Scoring covers answer structure, logical coherence, realism, gaze movement, and head movement. The result shows the overall and category scores alongside the question-and-answer transcript; the scoring formula and weights are undecided.
- Past interview records store question-and-answer transcripts on the phone along with the interview start date/time, company name, industry, job role, and interview type (HR/job-specific). Users can review past transcripts, displayed newest first by interview start date/time; list layout remains undecided.
- Users can delete one past record after a confirmation dialog. Confirmation deletes its transcript and basic information together; cancellation preserves the record.

HR interviews assess personality, values, collaboration, and motivation for applying. Job-specific interviews assess practical knowledge, problem-solving ability, and expertise relevant to the selected role. Gaze and head movement are observed during the interview; answer structure, logical coherence, and realism are evaluated after it ends.

## Tech Stack
<!-- TODO: language, framework, database, hosting. One line each. -->
- Language: Swift (approved).
- User interface: SwiftUI (approved).
- LLM validation runtime: MLX Swift LM (approved).
- Speech-to-text: Apple SpeechAnalyzer + SpeechTranscriber (approved).
- Text-to-speech: Apple AVSpeechSynthesizer (approved).
- Face tracking: Apple ARKit (approved).
- Local persistence: SwiftData with CloudKit automatic sync disabled (approved).
- Tests: Swift Testing (unit/integration), XCTest + XCUIAutomation (UI), XCTest (performance), approved.
- Minimum iOS version: 26.0 (approved).
- Remaining application stack: pending user approval.

## Getting Started

Build and run instructions will be added after the user approves the technology choices and application setup.

### Prerequisites
<!-- TODO: runtime versions, tools, accounts -->

### Install
```bash
# TODO
```

### Run
```bash
# TODO
```

## Documentation
| Document | What it covers |
|---|---|
| [AGENTS.md](AGENTS.md) | Rules for AI agents working in this repository |
| [TASK.md](TASK.md) | Current tasks |
| [docs/common/GIT_STRATEGY.md](docs/common/GIT_STRATEGY.md) | Branching and commits |
| [docs/system-design/ARCHITECTURE.md](docs/system-design/ARCHITECTURE.md) | Architecture and design decisions |
| [docs/system-design/DATA.md](docs/system-design/DATA.md) | Data model |
| [docs/system-design/OPERATIONS.md](docs/system-design/OPERATIONS.md) | Running, building, deploying |
| [docs/ui-design/SITE_MAP.md](docs/ui-design/SITE_MAP.md) | Screens and flows |

## License
<!-- TODO: fill in, or delete this section -->
