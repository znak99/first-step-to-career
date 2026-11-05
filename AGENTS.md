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
- Face tracking: Apple ARKit (approved; screen-region ratios approved; gaze calibration, distance criteria, tracking-quality criteria, and actual screen-coordinate mapping pending).
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
- Approved question count: default to 5 on first use and allow adjustment from 3 to 7 through settings or a similar menu. A next question interrupted by continue-speaking does not count; present its replacement under the same question number.
- Approved answer start: STT must detect at least one word from the new speech. Previously stored answer text does not satisfy the resumed-answer start condition. The no-response policy replaces the earlier unlimited first-word wait and also applies after continue-speaking.
- Approved no-response policy: for both a new answer and a continue-speaking request, if STT starts and detects no word for 7 seconds, ask again; if another 7-second STT wait after asking again also detects no word, terminate the interview and apply the approved penalties below. Repeat wording remains undecided.
- Approved completed-question criterion: count a question once STT detects at least one word from new speech and the answer subsequently ends after 3 seconds of silence. Continuing the same answer does not add another completed question. Assess answer quality through category scores.
- Approved new-question nonresponse penalty: overall score = the quality score based on completed questions × completed question count ÷ configured question count; use 0 when no question is completed. Category scores remain quality scores. Actual movement reference points, screen-coordinate mapping, and AI grading require approval.
- Approved failed-continuation penalty: retain the existing answer and its completed-question credit; subtract 5 points once from the completion-adjusted overall score, with a floor of 0. Category quality scores remain unchanged.
- Approved overall quality weights for both HR and job-specific interviews: structure 25, logic 30, realism 25, gaze 10, head 10. Calculate the pre-penalty overall score as the sum of each applicable category score multiplied by its weight, divided by the sum of applicable weights. If both movement categories are excluded because of the shared setting, front-camera failure, lack of TrueDepth, or tracking difficulty during preparation or the interview, divide the remaining weighted sum by 80. Apply approved nonresponse penalties afterward.
- Approved answer-category aggregation: after the interview, grade each completed question's structure, logic, and realism separately on a 0–100 scale; use the arithmetic mean for each category, giving every completed question equal weight. Evaluate the full original-plus-continued answer once per question. Exclude incomplete questions from the mean and apply the approved overall completion penalty. If none are completed, skip the mean and use the approved overall score of 0; category display in that case remains undecided.
- Approved structure rubric: assess clarity of the core answer, information order, focus without unnecessary digression/repetition, and an ending connected to the main point. Give each criterion 0 (not met), 1 (partly met), or 2 (met), with equal weight. Per-question structure score = sum / 8 × 100. Answer length and format remain flexible; no prescribed closing sentence is required. Actual AI grading and detailed calibration remain pending.
- Approved logic rubric: assess the presence of reasons, support for the conclusion, consistency within the same answer, and avoidance of unsupported leaps or overgeneralization. Give each criterion 0 (not met), 1 (partly met), or 2 (met), with equal weight. Per-question logic score = sum / 8 × 100. Evaluate the full original-plus-continued answer, then use the approved completed-question mean. Cross-question consistency checks, factual verification, and actual AI grading remain pending.
- Approved realism rubric: assess concrete actions, feasibility under time/resource/authority constraints, fit to the selected role and question context, and plausible outcomes. Give each criterion 0 (not met), 1 (partly met), or 2 (met), with equal weight. Per-question realism score = sum / 8 × 100. Evaluate the full original-plus-continued answer, then use the approved completed-question mean. Question-type calibration, domain/company fact verification, experience verification, reference-data policy, and actual AI grading remain pending.
- Approved movement-scoring coverage: score both applicable movement categories throughout the interval from interview start until immediately before results are displayed. Include question preparation/playback, first-word and no-response waits, repeat questions, answers and silence, continue-speaking, and post-interview evaluation waits. STT word detection and answer completion do not gate this coverage. Preparation before interview start is outside the interval. Screen-region ratios are approved below; actual mapping, normal-tracking quality criteria, notice presentation, and implementation remain pending.
- Approved movement-scoring process: check gaze and head once per second; each applicable category starts at 100 points. At every off-center check, deduct one amount from that category: 0.1 for slight departure from the central area, 0.2 for a larger departure, 0.3 near the screen edge, or 0.4 outside the screen. Accumulate these per-check deductions, including consecutive deviations, and keep scores within 0–100. Reference points, screen-coordinate mapping and calibration, camera configuration, and distinguishing tracking failure from an off-screen position remain undecided.
- Approved movement-scoring regions: use centered rectangles with widths and heights of 50%, 70%, and 90% of the screen dimensions. Deduct 0 inside the 50% rectangle, 0.1 in the rest of the 70% rectangle, 0.2 in the rest of the 90% rectangle, 0.3 in the rest of the screen, and 0.4 outside the screen. Boundary lines belong to the inner region; the screen edge itself is inside the screen. Actual gaze/head reference points, screen-coordinate mapping, calibration, and device validation remain pending.
- Approved preparation-screen tracking exclusion: if lighting or another reason makes movement tracking difficult during preparation, show a confirmation message and exclude both gaze and head from category scoring and the overall score, even when the shared setting is enabled and hardware is supported. Use the approved answer-only weighted calculation; do not substitute 0 or 100 or apply off-screen deductions. Tracking-quality criteria, message wording/buttons, confirmation flow, and rechecking remain undecided. Mid-interview exclusion is approved below; failure criteria and notice presentation remain undecided.
- Approved mid-interview tracking exclusion: if movement tracking becomes unavailable during the interview, notify the user, exclude both movement categories for the entire interview, and continue the interview. Exclude previously accumulated movement deductions from the overall score and use the approved answer-only weighted calculation. Apply the approved 3-second rule below; normal-tracking quality criteria, timing implementation, notice wording/presentation, and tracking operation after exclusion remain undecided.
- Approved mid-interview tracking duration: if normal tracking data for either gaze or head is unavailable for 3 consecutive seconds, apply the full movement exclusion above. For a shorter temporary gap, skip deductions only for the unavailable category at its missed checks and continue scoring after recovery; an observable category follows the existing rules. Do not join gaps separated by recovery. Use elapsed seconds, not three checks or STT silence. Normal-data quality criteria, gap/recovery detection, and timing implementation remain pending; preparation-screen quality criteria and observation duration are still undecided.
- Approved excluded-movement result display: show an excluded status and its reason instead of a numeric score for excluded gaze/head categories on the current result screen. Reasons follow the approved shared-setting, device/camera, preparation-tracking, and mid-interview-tracking conditions. Japanese wording, layout, and handling overlapping reasons remain undecided. Do not add scores or exclusion reasons to stored history without approval.
- Approved movement-scoring setting: one shared setting enables or disables gaze and head scoring together. Default to enabled on first use on scoring-capable devices. Keep the two scores separate. Apply the approved hardware and preparation/mid-interview tracking exclusion conditions even when enabled. Include applicable categories in the overall score using the approved applicable-weight formula; excluded categories are not zero scores. Persistence, when changes take effect, and camera behavior while disabled remain undecided.
- Approved score display: applicable category scores and the overall score use 0–100 and always show one decimal digit. Round half up at the second decimal place only for display; do not round intermediate calculations. Numeric types and remaining category-scoring formulas require approval.
- Approved answer completion: use 3 seconds of silence after the answer starts and show an animated countdown. After this interval, keep the continue-speaking button available while the LLM prepares or TTS reads the next question. Pressing it stops that preparation/playback, resumes the previous answer, and triggers question reconsideration using the full answer after completion. Remaining timing and edge cases require user approval.
- Approved evaluation resume: while the final answer is being evaluated, allow continue-speaking to stop evaluation and resume the last answer. Apply the existing STT start and 3-second silence rules, then reevaluate using the full answer. Behavior after the result is displayed remains undecided.
- Aim to support iPhone 13 and later where feasible, with iOS 26 or later required. Hardware support remains subject to validation.
- Server usage is undecided; prefer avoiding a server where feasible. Local persistence uses SwiftData with CloudKit automatic sync disabled. The remaining application stack, stored data fields, and storage policies require user approval.
- Approved interview history content: each final question and its full answer (original plus continued speech), interview start date/time, company name, industry, job role, and interview type (HR/job-specific), stored on the phone. Exclude interrupted questions from saved transcripts. Display history newest first by interview start date/time.
- Approved history deletion: let the user select one record, show a confirmation dialog, and delete its transcript and basic information together only on confirmation; cancellation preserves the record.
- Approved source staging: write transferable Swift sources under `ios_temp/` without creating an Xcode project. The user will create `FirstStepToCareer/` in Xcode and rename its outer folder to `ios/`. Keep app sources and test sources separate; do not move or overwrite the future project automatically.
- Commit approved changes in appropriate task units, including the task status and all affected documentation, and push immediately after every commit. Keep GitHub synchronized with the latest documentation and source code.
- The user has authorized these commits and pushes for approved work; do not ask for separate permission each time. Do not report a task as delivered until its push succeeds. Report any push failure.
- These project-specific approval and synchronization rules take precedence over conflicting template guidance.

## Hard Rules
- Never force-push to main (or develop).
- Never commit secrets, credentials, or .env files.
- Never install libraries, tools, or packages globally (outside the project) without the user's approval.
- Never run destructive commands (rm -rf, DROP, git reset --hard, history rewrites) without explicit confirmation.
- Do not edit template-owned documents (docs/common/*) unless the user asks. FEEDBACK.md is the exception.
