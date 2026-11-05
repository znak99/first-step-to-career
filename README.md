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
- Local model download: the [original model files](llm/README.md) (10 files, about 2.35 GB) have been downloaded and verified under `llm/`. Model files are excluded from Git; the production precision and app distribution method remain undecided. Japanese generation, mid-generation cancellation, and reuse after cancellation have been verified on Mac; iPhone performance remains unverified.
- Validation runtime: MLX Swift LM 3.32.3, mlx-swift 0.32.3, and swift-transformers 1.4.0, approved for the development test.
- Speech-to-text: Apple SpeechAnalyzer + SpeechTranscriber, approved for on-device recognition; device and Japanese-language support require validation.
- Text-to-speech: Apple AVSpeechSynthesizer, approved; voice, speaking rate, and playback validation remain pending.
- Gaze and head movement: Apple ARKit, approved; screen-region ratios approved. Calibration, distance criteria, tracking-quality criteria, actual screen-coordinate mapping, and device accuracy remain pending.
- Local persistence: SwiftData with CloudKit automatic sync disabled, approved; schema and remaining storage policies remain undecided.
- UI language: Japanese (`ja`).
- Release market: Japan only.
- Server: undecided; prefer avoiding a server where feasible.
- Remaining application stack and data model: undecided, pending user approval.
- The user-created Xcode project is under `ios/`. Question configuration, scoring, movement, tracking-gap, and interview-session sources are included in its app target, with a separate Swift Testing target. All staged files were migrated and `ios_temp/` was removed.
- The Japanese UI shell includes splash, onboarding, four tabs, and child-screen navigation. Results, history, schedules, and analysis have empty states. The separate Debug LLM test uses the local model; interview AI, speech, camera, interview execution, and persistence remain unconnected.
- Run `bash ios/Scripts/verify.sh` for iOS 26 source type checking and Mac unit tests. The shared Xcode scheme also includes a separate UI navigation test target. See [source integration instructions](ios/INTEGRATION.md).

## Features
- AI-led mock interviews configured by company name, industry, job role, and interview type (HR or job-specific).
- A question count that defaults to 5 on first use and is adjustable from 3 to 7 through settings or a similar menu.
- A next question interrupted by continue-speaking does not count toward the configured total. The reconsidered question uses the same question number.
- A preparation screen checks the distance needed to observe gaze and head movement. If the front camera does not work or the device lacks TrueDepth support, both movement categories are excluded from scoring and the overall score. If lighting or another reason makes tracking difficult during preparation, show a confirmation message and exclude both categories, even when the shared setting is enabled and hardware is supported. Excluded categories are not replaced with 0 or 100 or treated as off-screen deviations. Tracking-quality criteria, Japanese wording/buttons, confirmation flow, and rechecking remain undecided.
- Applicable gaze and head movement categories are scored throughout the interval from interview start until immediately before results are displayed, including AI question preparation/playback, waiting, repeat questions, answers and silence, continued answers, and post-interview evaluation waits. Unscored early termination ends observation and accumulation at termination without producing result scores. Preparation before interview start is outside this interval. Exit-confirmation dialog time is excluded under the approved full-pause rule below. Check each once per second, starting each applicable category at 100 points. Deduct 0.1 for slight departure from the central area, 0.2 for a larger departure, 0.3 near the screen edge, or 0.4 outside the screen. Accumulate one applicable deduction per category per check, including consecutive deviations. Use centered rectangles whose widths and heights are 50%, 70%, and 90% of screen dimensions: 0 inside the 50% rectangle, 0.1 in the rest of the 70% rectangle, 0.2 in the rest of the 90% rectangle, 0.3 in the rest of the screen, and 0.4 outside. Boundary lines belong to the inner region; the screen edge itself is inside the screen. Reference points, screen-coordinate mapping/calibration, tracking-failure criteria, camera configuration, and device validation remain undecided.
- If tracking becomes unavailable during the interview, notify the user, exclude both movement categories for the entire interview, and continue. Previously accumulated movement deductions are also excluded from the overall score; apply the approved answer-only weighted calculation. Apply the approved 3-second rule below; normal-tracking quality criteria, timing implementation, notice wording/presentation, and tracking operation after exclusion remain undecided.
- During the interview, apply the full movement exclusion if normal tracking data for either gaze or head is unavailable for 3 consecutive seconds. For a shorter temporary gap, skip deductions only for the unavailable category at its missed checks; continue scoring after recovery, while an observable category follows the existing rules. Gaps separated by recovery are not combined. The threshold uses elapsed time excluding exit-confirmation pause time, not three checks or STT silence. Normal-data quality criteria, gap/recovery detection, timing implementation, and preparation-screen observation criteria/duration remain undecided.
- On the current result screen, show an excluded status and its reason instead of a numeric score for excluded gaze/head categories. Reasons follow the approved setting, device/camera, preparation-tracking, and mid-interview-tracking conditions. Japanese wording, layout, and handling overlapping reasons remain undecided; stored history does not gain scores or exclusion reasons.
- One shared setting enables or disables gaze and head scoring together; their scores remain separate. Default to enabled on first use on scoring-capable devices. Disabled, unsupported, or preparation/mid-interview tracking-excluded categories are excluded from the overall score using the approved applicable-weight formula. Apply the shared setting chosen at interview start. Changes are prohibited after the interview starts; the user must end the mock interview before changing the setting for a newly started interview. Approved automatic exclusion conditions still take precedence. Persistence, lock presentation, settings-menu access during the interview, manual-exit details, and camera behavior while disabled remain undecided.
- When users request to end an ongoing mock interview, show a confirmation dialog. End only after confirmation; cancellation keeps the interview. Showing the dialog alone does not end the interview or unlock its movement-scoring setting. This also applies when ending to change that setting. The approved full-pause rule below applies while the dialog is displayed. Japanese wording/buttons remain undecided. Retain the prior company, industry, role, and interview type when returning to setup. Early-termination transcripts and basic metadata are not saved to history. Both user-confirmed early exit and automatic nonresponse termination are unscored; the confirmation step applies to manual exit.
- While the exit-confirmation dialog is displayed, stop all interview progress, AI question/evaluation processing and result application, question playback, answer recognition, response timers/animations, gaze/head observation and scoring, and tracking-gap timing. Preserve the phase, answers, scores, and timer state and resume them on cancellation using the response-timer grace rule below. Dialog time, speech, and observations do not count afterward. This is an exception to full-interval movement scoring. Actual stop/resume integration, playback position, event ordering, and UI remain pending.
- When the exit dialog is cancelled, add exactly 1 second to either active response timer (the 7-second first-word wait or 3-second answer-silence timer) if its unrounded remaining time is below 1 second; otherwise preserve it. A 0.9-second remainder becomes 1.9; exactly 1 second and 5 seconds stay unchanged. Dialog time is excluded. Tracking-gap timing and movement-check cadence receive no grace. Deadline event ordering and runtime integration remain pending.
- Questions are read aloud through text-to-speech (TTS). During the user's turn, speech-to-text (STT) displays the answer.
- Starting to speak means STT detects at least one word from the new speech, including when resuming an answer. Previously stored answer text does not satisfy a resumed answer's start condition.
- For both a new answer and a continue-speaking request, if STT starts and detects no word for 7 seconds, ask again. If another 7-second STT wait after asking again also detects no word, end the interview without evaluation, score calculation, or score display. This replaces the earlier unlimited first-word wait.
- After the answer starts, 3 seconds of silence indicate completion, with an animated countdown showing the time remaining. The continue-speaking button remains available while the LLM prepares or TTS reads the next question. Pressing it stops preparation/playback and resumes the previous answer; after the user finishes, the LLM reconsiders the next question using the full answer.
- While the final answer is being evaluated, users can select continue-speaking to stop evaluation and add to that answer. After completion, evaluation runs again using the full answer. The existing STT start and 3-second silence rules apply; resuming after results are displayed remains undecided.
- Scoring covers answer structure, logical coherence, realism, gaze movement, and head movement. Applicable category scores and the overall score use 0–100 and always show one decimal digit, rounded half up only for display, alongside the question-and-answer transcript. Intermediate calculations are not rounded. Actual movement reference points, screen-coordinate mapping, and AI grading remain undecided.
- Both interview types use the approved overall quality weights: structure 25%, logic 30%, realism 25%, gaze 10%, and head 10%. For normal completion, calculate the overall score as the weighted sum divided by the sum of applicable weights. When the shared setting, front-camera failure, lack of TrueDepth, or tracking difficulty during preparation or the interview excludes both movement categories, divide the remaining weighted sum by 80, using weights 25, 30, and 25, to keep the score on a 0–100 scale. Apply these weights to normally completed interviews; early exits and automatic nonresponse terminations produce no scores.
- After the interview, grade each completed question's structure, logic, and realism separately on a 0–100 scale and calculate each category's arithmetic mean. All completed questions have equal weight. Evaluate the full original-plus-continued answer once per question; exclude incomplete questions from the mean. User-confirmed early exit and automatic nonresponse termination, including zero completed questions, end without evaluation or scores.
- The approved structure rubric gives equal weight to the core answer, information order, focus, and ending. Each criterion receives 0 (not met), 1 (partly met), or 2 (met); the per-question structure score is their sum / 8 × 100. Answer length and format remain flexible, including how the answer ends. Actual AI grading and quality validation remain pending.
- The approved logic rubric gives equal weight to reasons, support for the conclusion, consistency within the same answer, and avoidance of unsupported leaps or overgeneralization. Each criterion receives 0 (not met), 1 (partly met), or 2 (met); the per-question logic score is their sum / 8 × 100. Evaluate the full original-plus-continued answer and use the approved completed-question mean. Cross-question comparison, factual verification, and actual AI grading remain pending.
- The approved realism rubric gives equal weight to concrete actions, feasibility under time/resource/authority constraints, fit to the role and question context, and plausible outcomes. Each criterion receives 0 (not met), 1 (partly met), or 2 (met); the per-question realism score is their sum / 8 × 100. Evaluate the full original-plus-continued answer and use the approved completed-question mean. Detailed calibration, factual verification, reference-data policy, and actual AI grading remain pending.
- Count a question as completed when STT detects at least one word from new speech and the answer subsequently ends after 3 seconds of silence. Continuing the same answer keeps that question's completion count at one; answer quality is assessed through category scores.
- History contains only normally completed interviews; user-confirmed early exits and automatic nonresponse terminations save neither transcripts nor basic metadata and create no history entry. Normal interview records store each final question and its full answer, combining original and continued speech, on the phone. Interrupted questions are excluded from saved transcripts. Records also include the interview start date/time, company name, industry, job role, and interview type (HR/job-specific). Users can review past transcripts, displayed newest first by interview start date/time; list layout remains undecided.
- Users can delete one past record after a confirmation dialog. Confirmation deletes its transcript and basic information together; cancellation preserves the record.

User-confirmed early exit and automatic nonresponse termination both end without evaluating answers, calculating category/overall scores, or displaying result scores. This replaces the previous completion-ratio and extra-5-point penalties and the zero-completion overall-0 fallback. Early-termination transcripts and basic metadata are not saved to history; both terminations return to the mock-interview setup screen for company, industry, role, and interview type. Retain the previous four setup inputs so the user can reuse or edit them without resuming old answers or creating history. Save/update these four inputs separately on the device only when a mock interview actually starts, and restore them after a full app exit/relaunch. Editing inputs or entering preparation alone does not update the saved values; closing the app before starting another interview preserves the previous saved conditions. This does not restore old answers/progress or create early-termination history. The interview starts when preparation checks are complete and generation of its first question begins; save the four inputs at that point. On first launch without saved conditions, leave company, industry, and role unfilled. Initial interview-type selection, required-field rules, input controls, storage technology/error handling, first-question generation failure handling, reset/backup behavior, exit-reason wording, and transition details remain undecided. The staged Core implements both unscored termination paths, rejects late results, and excludes early terminations from history eligibility. Actual storage and navigation driven by interview execution remain unimplemented.

HR interviews assess personality, values, collaboration, and motivation for applying. Job-specific interviews assess practical knowledge, problem-solving ability, and expertise relevant to the selected role. Gaze and head movement are observed during the interview; answer structure, logical coherence, and realism are evaluated after normal completion.

## Tech Stack
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

The user-created Xcode project is in `ios/FirstStepToCareer.xcodeproj`. Core sources and unit tests have been migrated into separate app and test targets; `ios_temp/` has been removed. Open the project and use the shared `FirstStepToCareer` scheme.

### Prerequisites
- Validated with Xcode 27.2, Swift 6.4.2, and SDK 27.2.
- The app deployment target remains iOS 26.0. App build and all 48 Swift Testing test functions passed on the iOS 27.0 iPhone 17 simulator. Physical-device testing is pending.

### Install
No external libraries or models are required for the staged core tests.

### Run
```bash
bash ios/Scripts/verify.sh
```

This checks the sources for iOS 26 with both default isolation configurations and runs 48 Swift Testing test functions, including parameterized cases, on the Mac. The verification package and build outputs are created only in a temporary directory. See [integration instructions](ios/INTEGRATION.md) for the migrated target layout and Xcode test command. The UI shell and navigation are implemented; persistence, AI, speech, tracking adapters, and actual interview execution are not connected. Setup and settings are held in memory only. Splash and onboarding appear on each launch in this initial shell; no onboarding-completion state is persisted.

## Documentation
| Document | What it covers |
|---|---|
| [AGENTS.md](AGENTS.md) | Rules for AI agents working in this repository |
| [TASK.md](TASK.md) | Current tasks |
| [docs/common/GIT_STRATEGY.md](docs/common/GIT_STRATEGY.md) | Branching and commits |
| [docs/system-design/ARCHITECTURE.md](docs/system-design/ARCHITECTURE.md) | Architecture and design decisions |
| [docs/system-design/DATA.md](docs/system-design/DATA.md) | Data model |
| [docs/system-design/OPERATIONS.md](docs/system-design/OPERATIONS.md) | Running, building, deploying |
| [docs/system-design/MLX_RESEARCH.md](docs/system-design/MLX_RESEARCH.md) | Runtime versions and model-format proposal; adoption pending approval |
| [docs/ui-design/SITE_MAP.md](docs/ui-design/SITE_MAP.md) | Screens and flows |

Exit-confirmation pause/cancel core handling preserves active time and rotates work/observation identifiers on resumption. The exit-confirmation UI and actual device/model suspension are not implemented.

## Local LLM development test

Debug iPhone builds include the existing BF16 model. Open the interview screen, then select `開発用：LLMテスト`. The screen accepts a prompt, streams generated text, and supports stopping generation. Each request starts a fresh conversation; prompts and outputs are not saved. Simulator builds show an execution limitation; Release builds omit the development entry and model.

Dependencies and build outputs use `ios/.build/`. No packages or toolchains are installed globally. This Mac uses a project-local Metal toolchain; Apple’s export command also retained a system download-cache copy. See [build and test commands](docs/system-design/OPERATIONS.md#개발용-llm-빌드실행-2026-11-05) before opening Xcode or building. iPhone installation, memory, speed, and output-quality validation remain pending.
