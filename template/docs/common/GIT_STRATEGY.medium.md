# GIT_STRATEGY.md

Branch, commit, PR, and release rules for this repository. Scale: medium.

## Branch Model
- `main` — the release branch. Only PRs from develop land here. Every merge into main triggers CI/CD automatically (see OPERATIONS.md). Never commit to main directly.
- `develop` — the work branch, created from main. All work is committed here.
- `exp/<topic>` — a throwaway branch from develop for a risky experiment. Delete it when done.
  Never merge it as-is; re-apply the useful parts as clean commits on develop.
- develop must always build and pass tests, because any commit on it may be released.
- There is no hotfix branch. An urgent fix is a task on develop followed by a release.

## Commit Rules
- Header only. No body.
- Format: `<type>: <한국어 제목> (T-012)` — English type, Korean title, task ID at the end.
  Optional scope: `feat(auth): 로그인 화면 추가 (T-012)`.
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
- Push develop after every commit, or at least when a task is done.

## Release
- A release is a task in TASK.md (for example `T-020 v0.3.0 릴리스`) and is started only when the user asks for a release.
- Steps for the agent:
  1. Make sure develop builds and passes tests, and that every task being released is in 완료 or DONE.md.
  2. Open a PR from develop to main. Set the release task to `review`.
  3. Wait. The user reviews and merges with a merge commit — never squash, because develop is long-lived and a squash would make its history diverge from main.
  4. After the merge, CI/CD runs on main automatically. Check that it succeeded, then move the release task to 완료.
- Writing the PR — this matters:
  - Write for someone who knows nothing about this project and nothing about code.
  - Describe what the user will see and be able to do — on screen, or in the output for a project without a UI. Not how the code changed. Mention code only when unavoidable.
  - Keep it very easy to understand: short sentences, no jargon.
  - Title: `release: <한국어 한 줄 요약>`.
  - Body in Korean:
    ```
    ## 이번 릴리스에서 달라지는 것   <!-- 사용자가 보게 될 변화를 화면 기준으로 -->
    ## 직접 확인하는 방법            <!-- 어느 화면에서 무엇을 누르면 되는지 순서대로 -->
    ## 포함된 태스크                 <!-- T-ID와 제목 목록 -->
    ## 주의할 점                     <!-- 없으면 "없음" -->
    ```

## Versioning
- Optional. When the user wants a version number, the user tags the merge commit on main `v0.1.0`, `v0.2.0` (semver-style).

## What Agents May Do
- Commit and push to develop. Create, force-push, and delete `exp/` branches. Open the release PR when the user asks.
- Not: push to main, merge PRs, create tags.

## Prohibited
- Force-pushing to main or develop, or rewriting any history already pushed to them.
- Direct commits to main.
- Committing secrets, credentials, .env files, or build output that belongs in .gitignore.
- Committing with failing tests or a broken build.
