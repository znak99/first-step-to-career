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
- A next question interrupted by continue-speaking does not count toward the configured total. The reconsidered question uses the same question number.
- A preparation screen checks the distance needed to observe gaze and head movement. If the front camera does not work or the device lacks TrueDepth support, both movement categories are excluded from scoring and the overall score.
- Questions are read aloud through text-to-speech (TTS). During the user's turn, speech-to-text (STT) displays the answer.
- Starting to speak means STT detects at least one word from the new speech, including when resuming an answer. Previously stored answer text does not satisfy a resumed answer's start condition.
- For both a new answer and a continue-speaking request, if STT starts and detects no word for 7 seconds, ask again. If another 7-second STT wait after asking again also detects no word, end the interview and deduct for unfinished progress. This replaces the earlier unlimited first-word wait; the penalty for failed continuation remains undecided.
- After the answer starts, 3 seconds of silence indicate completion, with an animated countdown showing the time remaining. The continue-speaking button remains available while the LLM prepares or TTS reads the next question. Pressing it stops preparation/playback and resumes the previous answer; after the user finishes, the LLM reconsiders the next question using the full answer.
- While the final answer is being evaluated, users can select continue-speaking to stop evaluation and add to that answer. After completion, evaluation runs again using the full answer. The existing STT start and 3-second silence rules apply; resuming after results are displayed remains undecided.
- Scoring covers answer structure, logical coherence, realism, gaze movement, and head movement. Applicable category scores and the overall score use 0–100, including decimals, and appear alongside the question-and-answer transcript. Decimal precision, rounding, the quality-scoring formula, and weights remain undecided.
- For termination caused by a new question receiving no answer, multiply the overall quality score based on completed questions by completed question count / configured question count. Category scores retain their quality scores; use an overall score of 0 if no question is completed. Completion criteria remain undecided.
- Past interview records store each final question and its full answer, combining original and continued speech, on the phone. Interrupted questions are excluded from saved transcripts. Records also include the interview start date/time, company name, industry, job role, and interview type (HR/job-specific). Users can review past transcripts, displayed newest first by interview start date/time; list layout remains undecided.
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
