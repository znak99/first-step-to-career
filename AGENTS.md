# AGENTS.md

This file is the entry point for every AI agent working in this repository.
Keep it short. Detailed rules live in the documents linked below.

## Profile
- Scale: small
- Type: Mobile
- Platform: iOS only
- Implementation language: Swift (approved).
- UI framework: SwiftUI (approved).
- Testing: Swift Testing for unit/integration tests; XCTest + XCUIAutomation for UI automation; XCTest for performance measurement (approved; test structure and acceptance criteria pending).
- Minimum iOS version: 26.0 (approved).
- Target devices: iPhone 13 and later if feasible; support remains subject to device and performance validation.
- First validation LLM: LFM2.5-1.2B-JP-202606 (approved; production adoption pending validation).
- Validation runtime: MLX Swift LM (approved; package version and integration settings pending).
- STT: Apple SpeechAnalyzer + SpeechTranscriber (approved, on-device; device and Japanese-language support pending validation).
- TTS: Apple AVSpeechSynthesizer (approved; voice, rate, and playback validation pending).
- Face tracking: Apple ARKit (approved; gaze calibration, distance criteria, and scoring thresholds pending).
- Local persistence: SwiftData with CloudKit automatic sync disabled (approved; schema and remaining storage policies pending).
- Server: undecided
- Service language: ja
- Release market: Japan only
- Template version: 1.0.0

## Project Overview
혼자서 면접을 연습하고 취업활동을 관리하기 위한 앱

See [README.md](README.md) for details.

## Language Policy
| Target | Language |
|---|---|
| AGENTS.md, README.md, docs/common/* | English |
| All other documents (TASK.md, DONE.md, docs/system-design/*, docs/ui-design/*) | Korean |
| Conversation and reports to the user | Korean |
| Commit messages, PR titles and bodies, code comments | Korean |
| Code identifiers (variables, functions, file names) | English |
| Text the end user sees in the product (UI labels, messages, i18n resources) | Service language (ja) |

The service language applies only to text the end user sees in the product. Even when the product is in English or Japanese, every other row stays as listed: documents, conversation, commits, PRs, and code comments remain in Korean.

## Documentation Map
| Document | Purpose | Read when | Update when |
|---|---|---|---|
| [docs/common/FEEDBACK.md](docs/common/FEEDBACK.md) | Corrections the user has given to agents | Every session, before any work | Immediately when the user corrects you — append one line |
| [TASK.md](TASK.md) | Current tasks and status | Every session start | A task starts, finishes, or is blocked |
| [DONE.md](DONE.md) | Archive of finished tasks | Only when past history is needed | When 완료 in TASK.md exceeds 10 entries |
| [docs/common/TASK_GUIDE.md](docs/common/TASK_GUIDE.md) | How to write TASK.md | Before editing TASK.md | Never (template-owned) |
| [docs/common/GIT_STRATEGY.md](docs/common/GIT_STRATEGY.md) | Branch, commit, PR, release rules | Before any git operation | Never (template-owned) |
| [docs/system-design/ARCHITECTURE.md](docs/system-design/ARCHITECTURE.md) | Stack, structure, design decisions | Before structural changes | Structure or a key decision changes |
| [docs/system-design/DATA.md](docs/system-design/DATA.md) | Entities, schema, migrations | Before touching the data layer | Schema changes |
| [docs/system-design/OPERATIONS.md](docs/system-design/OPERATIONS.md) | Run, build, deploy, env vars | Before running or deploying | Commands or env vars change |
| [docs/ui-design/SITE_MAP.md](docs/ui-design/SITE_MAP.md) | Screens, routes, flows | Before UI work | Screens or routes change |

## Workflow
1. Read FEEDBACK.md, then TASK.md.
2. Confirm which task to work on. If the user asks for work that is not in TASK.md, add it to TASK.md first — split into a task with sub-tasks as TASK_GUIDE.md describes — and record what it changes in the relevant design documents. If the task is unclear, ask before starting.
3. Investigate, then propose a plan: approach, files to change, risks. Wait for explicit approval before changing any code.
4. If the plan must change significantly during implementation, stop and re-confirm.
5. Follow GIT_STRATEGY.md for branches and commits.
6. Before reporting done: tests pass, and TASK.md and every affected document in the map above are updated — inside the commits themselves, as GIT_STRATEGY.md describes.
7. Report in Korean: what changed, which files, and what was not done.

Updating TASK.md and FEEDBACK.md as part of this workflow does not require approval.

## Communication
- **Important:** when reporting or explaining anything, assume the user has no prior knowledge of the topic. Use plain words, define terms the first time they appear, and never rely on unexplained jargon.
- Be brief and clear by default. When the user asks for more detail, go deeper, but keep it just as easy to understand.

## Working Principles
- Do only what the task asks. No unrequested features or refactors.
- Prefer the smallest change that solves the problem. Match existing patterns.
- Do not add dependencies without asking.
- Keep comments minimal. Explain why, not what.
- Never report a task as done without verifying it works.

## Project-Specific Rules
- Obtain explicit user approval before making project decisions or changing the approved scope. Do not turn preferences or undecided items into final decisions.
- Develop an iOS-only app with Japanese UI for release only in Japan.
- Approved question count: default to 5 on first use and allow adjustment from 3 to 7 through settings or a similar menu.
- Approved answer start: after question playback or a continue-speaking request, wait without automatic completion until STT detects at least one word from the new speech. Previously stored answer text does not satisfy the resumed-answer start condition.
- Approved answer completion: use 3 seconds of silence after the answer starts and show an animated countdown. After this interval, keep the continue-speaking button available while the LLM prepares or TTS reads the next question. Pressing it stops that preparation/playback, resumes the previous answer, and triggers question reconsideration using the full answer after completion. Remaining timing and edge cases require user approval.
- Aim to support iPhone 13 and later where feasible, with iOS 26 or later required. Hardware support remains subject to validation.
- Server usage is undecided; prefer avoiding a server where feasible. Local persistence uses SwiftData with CloudKit automatic sync disabled. The remaining application stack, stored data fields, and storage policies require user approval.
- Approved interview history content: question-and-answer transcripts, interview start date/time, company name, industry, job role, and interview type (HR/job-specific), stored on the phone. Display history newest first by interview start date/time.
- Approved history deletion: let the user select one record, show a confirmation dialog, and delete its transcript and basic information together only on confirmation; cancellation preserves the record.
- Commit approved changes in appropriate task units, including the task status and all affected documentation, and push immediately after every commit. Keep GitHub synchronized with the latest documentation and source code.
- The user has authorized these commits and pushes for approved work; do not ask for separate permission each time. Do not report a task as delivered until its push succeeds. Report any push failure.
- These project-specific approval and synchronization rules take precedence over conflicting template guidance.

## Hard Rules
- Never force-push to main (or develop).
- Never commit secrets, credentials, or .env files.
- Never install libraries, tools, or packages globally (outside the project) without the user's approval.
- Never run destructive commands (rm -rf, DROP, git reset --hard, history rewrites) without explicit confirmation.
- Do not edit template-owned documents (docs/common/*) unless the user asks. FEEDBACK.md is the exception.
