# GIT_STRATEGY.md

Branch and commit rules for this repository. Scale: small.

## Branch Model
- `main` — the only long-lived branch. All work is committed directly to main.
- main must always work: every commit on main passes tests.
- `exp/<topic>` — a throwaway branch for a risky experiment. Delete it when done.
  Never merge it as-is; re-apply the useful parts as clean commits on main.

## Commit Rules
- Header only. No body.
- Format: `<type>: <한국어 제목>` — English type, Korean title.
  Optional scope: `feat(auth): 로그인 화면 추가`.
- Types: feat, fix, refactor, docs, test, chore, style, perf, build, ci.
- Title: one line, 50 characters or fewer, no trailing period.
- One commit per sub-task in TASK.md. A commit contains, together:
  1. the TASK.md update (the sub-task checked off; for the last sub-task, the task moved to 완료),
  2. the change itself,
  3. any document updates the change requires.
  Do not commit a TASK.md update separately from the work it describes.
- A FEEDBACK.md addition rides along with the next commit.
- A status-only change in TASK.md with no code (for example a release task moving to `review`) may be its own `chore:` commit.
- Run tests before every commit.

## Integration
- No pull requests. Commit to main and push.
- Push after every commit, or at least when a task is done.

## Versioning
- None. Tag a milestone `v0.1.0` only when the user asks; the user creates the tag.

## What Agents May Do
- Commit and push to main. Create, force-push, and delete `exp/` branches.
- Not: create tags.

## Prohibited
- Force-pushing to main, or rewriting any history already pushed to main.
- Committing secrets, credentials, .env files, or build output that belongs in .gitignore.
- Committing with failing tests or a broken build.
