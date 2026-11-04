# AGENTS.md

This file is the entry point for every AI agent working in this repository.
Keep it short. Detailed rules live in the documents linked below.

## Profile
- Scale: {{SCALE}}                        <!-- small | medium | large -->
- Type: {{TYPE}}                          <!-- Web | Mobile | Web + Mobile | Tool (utility app with a UI, web or desktop) | Script (no UI) -->
- Server: {{HAS_SERVER}}                  <!-- yes | no -->
- Service language: {{SERVICE_LANGUAGE}}  <!-- ko | en | ja | ... — applies to UI text only -->
- Template version: {{TEMPLATE_VERSION}}

## Project Overview
{{PROJECT_ONE_LINER}}

See [README.md](README.md) for details.

## Language Policy
| Target | Language |
|---|---|
| AGENTS.md, README.md, docs/common/* | English |
| All other documents (TASK.md, DONE.md, docs/system-design/*, docs/ui-design/*) | Korean |
| Conversation and reports to the user | Korean |
| Commit messages, PR titles and bodies, code comments | Korean |
| Code identifiers (variables, functions, file names) | English |
| Text the end user sees in the product (UI labels, messages, i18n resources) | Service language ({{SERVICE_LANGUAGE}}) |

The service language applies only to text the end user sees in the product. Even when the product is in English or Japanese, every other row stays as listed: documents, conversation, commits, PRs, and code comments remain in Korean.

## Documentation Map
<!-- Remove the rows for documents this project does not have (see Profile).
     Web + Mobile: replace the SITE_MAP.md row with one row each for docs/ui-design/SITE_MAP.web.md and SITE_MAP.mobile.md. -->
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
<!-- TODO: Fill in at project start — stack conventions, test/lint/format commands, anything unique to this project. -->

## Hard Rules
- Never force-push to main (or develop).
- Never commit secrets, credentials, or .env files.
- Never install libraries, tools, or packages globally (outside the project) without the user's approval.
- Never run destructive commands (rm -rf, DROP, git reset --hard, history rewrites) without explicit confirmation.
- Do not edit template-owned documents (docs/common/*) unless the user asks. FEEDBACK.md is the exception.
