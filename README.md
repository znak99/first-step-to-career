# personal-project-init

AI 에이전트와 함께 개발하는 토이 프로젝트에 공통으로 넣는 문서 템플릿입니다.
`template/` 아래의 파일을 새 프로젝트에 복사하고 변형을 고르고 placeholder를 채우면 되는데, 그 일을 `skills/new-project`의 Claude Code 스킬이 대신합니다.

현재 템플릿 버전: **1.0.0**

## 1. 구조

```
template/
├── AGENTS.md                      에이전트 진입점. 언어 정책, 문서 지도, 작업 순서, 금지 사항
├── CLAUDE.md                      @AGENTS.md 임포트 + Claude Code 전용 사항
├── README.md                      프로젝트 소개 (사람용)
├── TASK.{small,medium}.md         현재 작업 목록
├── DONE.md                        완료 태스크 보관함
└── docs/
    ├── common/                    에이전트 규칙 (영어, 템플릿 소유)
    │   ├── FEEDBACK.md            사용자가 에이전트에게 한 지적 모음
    │   ├── TASK_GUIDE.{small,medium}.md
    │   └── GIT_STRATEGY.{small,medium,large}.md
    ├── system-design/             설계 문서 (한국어, 프로젝트 소유)
    │   ├── ARCHITECTURE.md
    │   ├── DATA.md
    │   └── OPERATIONS.{small,medium,large}.md
    └── ui-design/
        └── SITE_MAP.md
skills/
└── new-project/                   Claude Code 스킬
    ├── SKILL.md                   질문 → 생성 → 초기 커밋 절차
    └── init.py                    생성 스크립트 (변형 선택, 문서 포함, placeholder 치환, 행 삭제)
```

파일명에 `.small` `.medium` `.large`가 붙은 것은 규모별 변형입니다. 생성할 때 하나를 골라 접미사 없는 이름으로 복사합니다.

## 2. 설치와 적용

### 2.1 GitHub에 올리기 (최초 한 번)
1. 이 폴더를 GitHub 저장소 `personal-project-init`로 푸시한다.
2. 저장소 Settings → General → **Template repository**를 켠다. 이제 "Use this template" 버튼이 생긴다.
3. `skills/new-project/SKILL.md` 상단의 `TEMPLATE_REPO`를 본인 저장소 주소로 바꾼다.

### 2.2 Claude Code 스킬 설치 (최초 한 번)
저장소가 Public이므로 로그인 없이 받을 수 있다.
```bash
git clone --depth 1 https://github.com/znak99/personal-project-init /tmp/ppi
cp -r /tmp/ppi/skills/new-project ~/.claude/skills/
```
git이 없으면 GitHub 저장소 페이지에서 Code → Download ZIP으로 받아 풀고, `skills/new-project` 폴더만 `~/.claude/skills/`에 복사해도 같다.

Claude Code를 다시 시작하면 `/new-project`로 쓸 수 있고, "새 프로젝트 만들어줘"라고 해도 스킬이 뜬다.
스킬 폴더(`skills/new-project`)를 고쳤을 때는 위 두 줄을 다시 실행하면 된다. 저장소를 로컬에 상시 clone해 두는 경우라면 복사 대신 심볼릭 링크(`ln -s`)를 걸어 두면 자동으로 따라간다.

### 2.3 새 프로젝트를 만드는 두 가지 방법

**방법 A — Claude Code 스킬 (권장)**
아무 폴더에서 Claude Code를 열고 "새 프로젝트 만들어줘"라고 한다. 스킬이 3.1의 여섯 가지를 묻고, GitHub에서 템플릿을 받아 새 폴더에 생성하고, 초기 커밋과 develop 브랜치까지 만든다.

**방법 B — GitHub 템플릿 저장소**
GitHub에서 "Use this template"으로 새 저장소를 만들고 clone한다. 그 폴더 안에는 `template/`와 `skills/`가 그대로 들어 있다. 그 상태에서:
- Claude Code를 열고 "초기화해줘"라고 하면 스킬이 in-place 모드로 동작해 현재 폴더에 생성하고 `template/`·`skills/`를 지운다.
- Claude Code 없이 하려면 스크립트를 직접 돌린다:
  ```bash
  python3 skills/new-project/init.py --in-place \
    --name my-app --one-liner "한 줄 소개" --scale medium --type Web --server yes --lang ko
  ```
- 스크립트도 쓰지 않으려면 3장의 규칙대로 손으로 복사·치환·삭제한다.

어느 방법이든 끝나면 에이전트에게 "AGENTS.md를 읽고 TASK.md의 첫 태스크를 시작해 달라"고 하면 된다.

## 3. 생성 규칙 (init.py가 하는 일)

### 3.1 먼저 정할 것

| 항목 | 선택지 | 결정하는 것 |
|---|---|---|
| 프로젝트 이름 | 자유 | `{{PROJECT_NAME}}` |
| 한 줄 소개 | 자유 | `{{PROJECT_ONE_LINER}}` |
| 규모 (Scale) | small / medium / large | 어떤 변형 파일을 쓰는가 (3.2) |
| 종류 (Type) | Web / Mobile / Web + Mobile / Tool / Script | 어떤 문서를 포함하는가 (3.3) |
| 서버 (Server) | yes / no | DATA.md 포함 여부 (3.3) |
| 서비스 언어 | ko / en / ja / … | UI 문구의 언어. 그 외 모든 것은 한국어 |

규모의 기준:
- **small** — main 브랜치 하나에서 바로 커밋. PR 없음. 태스크에 ID 없음
- **medium** — main(릴리스) + develop(작업). 릴리스할 때만 develop → main PR. main 머지 시 CI/CD 자동 실행. 태스크에 `T-001` ID
- **large** — medium과 같고, 커밋 메시지에 본문 필수, semver 버전 태그 필수

Type 보충:
- **Tool** — UI가 있는 유틸리티 앱. 웹이거나 데스크톱 앱
- **Script** — UI 없음

### 3.2 규모별 변형 선택

| 복사할 파일 | small | medium | large |
|---|---|---|---|
| `TASK.md` | TASK.small.md | TASK.medium.md | TASK.medium.md |
| `docs/common/TASK_GUIDE.md` | .small | .medium | .medium |
| `docs/common/GIT_STRATEGY.md` | .small | .medium | .large |
| `docs/system-design/OPERATIONS.md` | .small | .medium | .large |

나머지 파일은 변형이 없고 그대로 복사합니다.

### 3.3 문서 포함 규칙

| 문서 | 포함 조건 |
|---|---|
| `docs/ui-design/SITE_MAP.md` | Type이 Script가 아닐 때 |
| `docs/system-design/DATA.md` | Server가 yes이거나, Type이 Script가 아닐 때 |
| 그 외 전부 | 항상 |

즉 "Server 없는 Script"만 두 문서가 모두 빠지고, "Server 있는 Script"는 DATA.md만 들어갑니다.

Type이 **Web + Mobile**이면 `SITE_MAP.md`를 `SITE_MAP.web.md`와 `SITE_MAP.mobile.md` 두 개로 복사하고, 각 파일의 화면 ID 예시를 `W-01`, `M-01`로 바꿉니다.

### 3.4 placeholder 치환

`{{UPPER_SNAKE}}` 형식만 생성 시 치환 대상입니다. `[화면 이름]`처럼 대괄호로 된 것과 `<!-- -->` 주석은 에이전트가 프로젝트를 진행하며 채우는 자리이므로 건드리지 않습니다.

| placeholder | 값 | 위치 |
|---|---|---|
| `{{PROJECT_NAME}}` | 프로젝트 이름 | README.md |
| `{{PROJECT_ONE_LINER}}` | 한 줄 소개 | AGENTS.md, README.md |
| `{{SCALE}}` | small / medium / large | AGENTS.md |
| `{{TYPE}}` | Web / Mobile / Web + Mobile / Tool / Script | AGENTS.md |
| `{{HAS_SERVER}}` | yes / no | AGENTS.md |
| `{{SERVICE_LANGUAGE}}` | ko / en / ja / … | AGENTS.md (2곳) |
| `{{TEMPLATE_VERSION}}` | 이 문서 상단의 현재 버전 | AGENTS.md |
| `{{PORT}}` | 생성 시 비워 둠 | OPERATIONS.md — 초기 설정 태스크에서 에이전트가 채움 |
| `{{VERSION_FILE}}` | 생성 시 비워 둠 | GIT_STRATEGY.large.md — 초기 설정 태스크에서 에이전트가 채움 |

### 3.5 생성 후 손질
<!-- init.py를 쓰면 1~4는 자동이다. 손으로 할 때만 필요하다. -->

1. **AGENTS.md** — Documentation Map에서 포함하지 않은 문서의 행을 지운다. Web + Mobile이면 SITE_MAP 행을 web·mobile 두 행으로 바꾼다
2. **README.md** — Documentation 표에서 같은 작업을 한다
3. **TASK.md** — `프로젝트 초기 설정` 태스크의 하위 작업 중 포함하지 않은 문서의 줄을 지운다
4. **FEEDBACK.md** — 템플릿의 Common 섹션을 그대로 가져왔는지 확인한다. This project 섹션은 비어 있어야 한다
5. medium·large이면 저장소에 `develop` 브랜치가 필요하다. 초기 설정 태스크의 첫 하위 작업이므로 에이전트에게 맡겨도 된다

## 4. 템플릿 갱신

### 4.1 버전
템플릿 파일을 고치면 이 문서 상단의 버전을 올리고 아래 이력에 한 줄 적습니다. 문구 수정은 patch, 규칙 추가·변경은 minor, 구조 변경(파일 추가·삭제·이동)은 major입니다.

### 4.2 기존 프로젝트에 반영
프로젝트의 AGENTS.md Profile에 적힌 `Template version`과 현재 버전을 비교해서 반영합니다.

| 파일 | 반영 방법 |
|---|---|
| `docs/common/TASK_GUIDE.md`, `GIT_STRATEGY.md`, `OPERATIONS.md`의 규칙 부분 | 템플릿 소유이므로 새 버전으로 덮어쓴다 (OPERATIONS는 프로젝트가 채운 내용이 있으므로 구조 변경 때만 수동 병합) |
| `docs/common/FEEDBACK.md` | Common 섹션만 새 버전으로 바꾼다. This project 섹션은 그대로 둔다 |
| `AGENTS.md` | Profile 값, Project Overview, Project-Specific Rules, 지운 문서 행은 프로젝트 것이고 나머지는 템플릿 것이다. 수동으로 병합한다 |
| `TASK.md`, `DONE.md`, `README.md`, 설계 문서 | 프로젝트 소유. 템플릿 변경을 반영하지 않는다 |

반영이 끝나면 AGENTS.md의 `Template version`을 올립니다.

### 4.3 FEEDBACK 승격
여러 프로젝트에서 반복되는 지적은 프로젝트의 `This project` 섹션에서 템플릿의 `template/docs/common/FEEDBACK.md` Common 섹션으로 옮깁니다. 옮긴 뒤 버전을 올리면 다음 프로젝트부터 처음부터 적용됩니다.

### 4.4 규모 변경
프로젝트가 커져서 small → medium으로 올릴 때:
1. 3.2 표에 따라 네 파일을 새 변형으로 교체한다
2. AGENTS.md Profile의 Scale을 바꾼다
3. TASK.md의 기존 태스크에 ID를 붙이고 `현재 목표` 섹션을 추가한다
4. `develop` 브랜치를 만들고, 이후 작업은 develop에서 한다
5. CI/CD 워크플로를 만든다 (main 머지 시 자동 배포)

## 5. 버전 이력
- 1.0.0 — 최초 작성
