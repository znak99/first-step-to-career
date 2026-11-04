---
name: new-project
description: personal-project-init로 새 토이 프로젝트의 문서 세트를 만드는 스킬. "새 프로젝트 만들어줘", "프로젝트 초기화해줘", "템플릿으로 시작하자", "new project" 같은 요청에 사용한다. 현재 폴더에 template/ 디렉터리가 있는 저장소(GitHub 템플릿으로 만든 것)에서 "초기화해줘"라고 해도 사용한다. 규모·종류·서버·서비스 언어를 묻고 init.py로 문서를 생성한 뒤 git 초기 커밋까지 한다. 생성된 문서의 내용을 채우는 것은 이 스킬의 일이 아니다.
---

# new-project

템플릿 저장소: `TEMPLATE_REPO=https://github.com/znak99/personal-project-init`
(스킬을 설치한 뒤 이 줄을 본인 저장소 주소로 바꾼다.)

## 실행 환경
이 스킬은 로컬 파일 시스템과 git이 필요하므로 **Claude Code에서만** 실행한다. claude.ai 채팅이나 Cowork에서 호출되면 "이 스킬은 Claude Code(데스크톱 앱의 Code 탭 또는 터미널)에서 실행해 주세요"라고 안내하고 멈춘다.

## 순서

### 1. 모드 판단
- 현재 폴더에 `template/AGENTS.md`가 있으면 **in-place 모드**. GitHub의 "Use this template"으로 만든 저장소이므로 현재 폴더에 생성한다.
- 없으면 **새 폴더 모드**. `git clone --depth 1 <TEMPLATE_REPO> /tmp/personal-project-init`로 템플릿을 받고, 프로젝트 이름과 같은 새 폴더에 생성한다.

### 2. 질문
AskUserQuestion으로 한 번에 묻는다. 대화에서 이미 답이 나온 항목은 묻지 않는다.
1. 프로젝트 이름 — 새 폴더 모드면 폴더 이름으로도 쓴다
2. 한 줄 소개
3. 규모 — small / medium / large
   - small: main 하나에서 바로 커밋, PR 없음
   - medium: main(릴리스) + develop(작업), 릴리스할 때만 PR, main 머지 시 CI/CD 자동
   - large: medium과 같고 커밋 본문 필수, semver 태그 필수
4. 종류 — Web / Mobile / Web + Mobile / Tool / Script
   - Tool: UI가 있는 유틸리티 앱 (웹 또는 데스크톱)
   - Script: UI 없음
5. 서버 — yes / no
6. 서비스 언어 — ko / en / ja / 기타. UI 문구에만 적용되고 나머지는 전부 한국어

### 3. 생성
이 SKILL.md와 같은 폴더에 있는 `init.py`를 실행한다. 개인 스킬로 설치했다면 `~/.claude/skills/new-project/init.py`다.

```bash
# in-place 모드
python3 ~/.claude/skills/new-project/init.py --in-place \
  --name "<이름>" --one-liner "<한 줄 소개>" --scale <규모> --type "<종류>" --server <yes|no> --lang <언어>

# 새 폴더 모드
python3 ~/.claude/skills/new-project/init.py \
  --src /tmp/personal-project-init/template --dest ./<이름> \
  --name "<이름>" --one-liner "<한 줄 소개>" --scale <규모> --type "<종류>" --server <yes|no> --lang <언어>
```

- `--type`에 공백이 있으면("Web + Mobile") 반드시 따옴표로 감싼다.
- 스크립트가 실패하면(충돌 파일 등) 출력을 그대로 보여주고 멈춘다. 파일을 손으로 복사해서 대신하지 않는다.

### 4. git
- 새 폴더 모드: 생성된 폴더에서 `git init -b main`.
- main에서 전체를 커밋한다: `chore: 프로젝트 템플릿 초기화`
- medium·large: `git checkout -b develop`. 이후 모든 작업은 develop에서 한다. TASK.md의 첫 하위 작업 "develop 브랜치 생성"은 T-001을 시작할 때 바로 체크하면 된다.
- 원격 저장소는 연결하지 않는다. 사용자가 원하면 명령만 안내한다.

### 5. 보고
한국어로, 아무것도 모르는 사람에게 설명하듯 짧게:
- 만든 폴더, Profile(규모·종류·서버·언어), 포함된 문서와 제외된 문서, 현재 브랜치
- `{{PORT}}`와 `{{VERSION_FILE}}`은 비어 있으며 초기 설정 태스크에서 채워진다는 것
- 다음 할 일: "AGENTS.md를 읽고 TASK.md의 첫 태스크(프로젝트 초기 설정)를 시작해 줘"라고 말하면 된다는 것

## 하지 않는 것
- 생성된 문서의 내용을 고치거나 채우지 않는다. 그것은 첫 태스크(프로젝트 초기 설정)의 일이다.
- 의존성 설치나 프레임워크 스캐폴딩을 하지 않는다.
- 템플릿 저장소 자체를 수정하지 않는다.
