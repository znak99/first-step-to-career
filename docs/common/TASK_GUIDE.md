# TASK_GUIDE.md

How to write and maintain TASK.md and DONE.md. Both are written in Korean; this guide is in English.

## Purpose
TASK.md is the single source of truth for what is being worked on, what comes next, and what was recently done.
DONE.md is the archive of everything finished before that.
Agents read TASK.md at the start of every session and update it before reporting done. DONE.md is read only when past history is needed.

## Structure of TASK.md
1. `## 진행 중` — the task being worked on now. At most one.
2. `## 할 일` — tasks not started, in priority order. Top = next.
3. `## 완료` — finished tasks, newest first. Keep the latest 10 here; move the rest to DONE.md.

## Task Format
```
- [ ] 로그인 기능
  - [x] 로그인 엔드포인트 작성
  - [ ] 로그인 서비스 로직 작성
  - [ ] 입력 유효성 검사 작성
  - [ ] 로그인 폼 작성
- [ ] 비밀번호 재설정 — 보류: 메일 서버 미정
- [x] 프로젝트 초기 설정 (2026-10-13)
```
- Task line: checkbox and title. No IDs and no status words. The section a task sits in is its status; the checkbox marks completion.
- Sub-task lines: indented two spaces under their task. Checkbox and title only.
- Title: Korean, imperative, one line, specific enough to verify when done.
- A task that cannot proceed stays in 진행 중 with ` — 보류: 이유` appended.
- Completed tasks get the date in parentheses.

## Task Granularity
- A task is one unit of delivery: usually a feature or a self-contained change the user asked for. It is what you report as done.
- Sub-tasks are the smallest pieces of work that can be finished and verified on their own, listed in the order they should be done. One sub-task is usually one commit. The agent decides the split.
  Example: "로그인 기능" → 로그인 엔드포인트 작성 / 로그인 서비스 로직 작성 / 입력 유효성 검사 작성 / 로그인 폼 작성.
- Split a task when it is added if the scope is clear; otherwise when it is started, as part of the plan proposed for approval. A task that needs no split has no sub-tasks.
- Check off each sub-task as soon as it is done, not at the end.
- If the user asks for work that is not in TASK.md, add it this way first, then record what it changes in the relevant design documents (ARCHITECTURE.md, DATA.md, SITE_MAP.md, OPERATIONS.md).

## Lifecycle
- Add: when the user requests work, or when an agent discovers a necessary follow-up. Agents may add tasks freely, but must insert each one at the position that matches its priority relative to the existing tasks. Do not append blindly to the bottom, and do not move existing tasks.
- Start: move to 진행 중 and make sure the sub-tasks are listed. Starting a task follows the normal approval workflow in AGENTS.md.
- Finish: when the Definition of Done is met, remove the sub-task lines, check the box, add the date, and move the task to the top of 완료, in the same commit as the last sub-task (see GIT_STRATEGY.md). If 완료 now has more than 10 entries, move the oldest ones to the top of DONE.md in the same line format.

## Definition of Done
- All sub-tasks are checked.
- The change works and was verified: tests pass, or manual verification is noted in the task.
- Test data for the change is added — boundary values, min/max lengths, special characters, invalid formats, and the other cases listed in DATA.md section 7.1 (in test fixtures when the project has no DATA.md).
- Every affected document in the AGENTS.md Documentation Map is updated.
- Committed to main per GIT_STRATEGY.md.
- TASK.md (and DONE.md if needed) is updated.

## Agent Rules
- Read TASK.md at session start. Do not work on anything that is not listed; add it first.
- One task in 진행 중 at a time.
- Do not reorder existing tasks in 할 일. Priority belongs to the user.
- Do not edit this guide.
