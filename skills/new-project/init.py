#!/usr/bin/env python3
"""personal-project-init 생성 스크립트.

template/ 아래의 파일을 새 프로젝트에 복사하면서
  - 규모(small/medium/large)에 맞는 변형 파일을 고르고
  - 종류(Type)와 서버 유무에 따라 DATA.md / SITE_MAP.md 포함 여부를 정하고
  - {{PLACEHOLDER}}를 치환하고
  - AGENTS.md / README.md / TASK.md에서 포함하지 않은 문서의 행을 지운다.

사용 예:
  python3 init.py --src ./personal-project-init/template --dest ./my-app \
      --name my-app --one-liner "할 일을 관리하는 작은 웹앱" \
      --scale medium --type Web --server yes --lang ko

  # "Use this template"으로 만든 저장소 안에서 (template/가 현재 폴더에 있을 때):
  python3 skills/new-project/init.py --in-place --name ... --one-liner ... --scale ... --type ... --server ... --lang ...
"""
import argparse
import re
import shutil
import sys
from pathlib import Path

SCALES = ("small", "medium", "large")
TYPES = ("Web", "Mobile", "Web + Mobile", "Tool", "Script")

# 생성될 파일 -> 규모별 원본 파일
VARIANTS = {
    "TASK.md": {"small": "TASK.small.md", "medium": "TASK.medium.md", "large": "TASK.medium.md"},
    "docs/common/TASK_GUIDE.md": {
        "small": "docs/common/TASK_GUIDE.small.md",
        "medium": "docs/common/TASK_GUIDE.medium.md",
        "large": "docs/common/TASK_GUIDE.medium.md",
    },
    "docs/common/GIT_STRATEGY.md": {
        "small": "docs/common/GIT_STRATEGY.small.md",
        "medium": "docs/common/GIT_STRATEGY.medium.md",
        "large": "docs/common/GIT_STRATEGY.large.md",
    },
    "docs/system-design/OPERATIONS.md": {
        "small": "docs/system-design/OPERATIONS.small.md",
        "medium": "docs/system-design/OPERATIONS.medium.md",
        "large": "docs/system-design/OPERATIONS.large.md",
    },
}
PLAIN = [
    "AGENTS.md",
    "CLAUDE.md",
    "DONE.md",
    "README.md",
    "docs/common/FEEDBACK.md",
    "docs/system-design/ARCHITECTURE.md",
]
DATA = "docs/system-design/DATA.md"
SITE_MAP = "docs/ui-design/SITE_MAP.md"


def parse_args():
    p = argparse.ArgumentParser(description="personal-project-init 생성 스크립트")
    p.add_argument("--src", help="template/ 디렉터리 (--in-place면 생략)")
    p.add_argument("--dest", help="새 프로젝트 디렉터리 (--in-place면 생략, 현재 폴더)")
    p.add_argument("--in-place", action="store_true",
                   help="현재 폴더의 template/를 써서 현재 폴더에 생성하고, template/와 skills/를 지운다")
    p.add_argument("--name", required=True, help="프로젝트 이름")
    p.add_argument("--one-liner", required=True, help="한 줄 소개")
    p.add_argument("--scale", required=True, choices=SCALES)
    p.add_argument("--type", required=True, choices=TYPES, help='Web | Mobile | "Web + Mobile" | Tool | Script')
    p.add_argument("--server", required=True, choices=("yes", "no"))
    p.add_argument("--lang", required=True, help="서비스 언어: ko | en | ja | ...")
    p.add_argument("--template-version", help="생략하면 template/../README.md에서 읽는다")
    p.add_argument("--force", action="store_true", help="대상에 같은 파일이 있어도 덮어쓴다")
    a = p.parse_args()
    if a.in_place:
        a.dest = Path.cwd()
        a.src = a.dest / "template"
    else:
        if not a.src or not a.dest:
            p.error("--src와 --dest가 필요합니다 (또는 --in-place)")
        a.src, a.dest = Path(a.src).resolve(), Path(a.dest).resolve()
    return a


def read_template_version(src: Path) -> str:
    readme = src.parent / "README.md"
    if readme.exists():
        m = re.search(r"현재 템플릿 버전:\s*\*\*(.+?)\*\*", readme.read_text(encoding="utf-8"))
        if m:
            return m.group(1).strip()
    return "unknown"


def main():
    a = parse_args()
    if not (a.src / "AGENTS.md").exists():
        sys.exit(f"템플릿을 찾을 수 없습니다: {a.src}")

    web_mobile = a.type == "Web + Mobile"
    include_sitemap = a.type != "Script"
    include_data = a.server == "yes" or a.type != "Script"
    version = a.template_version or read_template_version(a.src)

    subs = {
        "{{PROJECT_NAME}}": a.name,
        "{{PROJECT_ONE_LINER}}": a.one_liner,
        "{{SCALE}}": a.scale,
        "{{TYPE}}": a.type,
        "{{HAS_SERVER}}": a.server,
        "{{SERVICE_LANGUAGE}}": a.lang,
        "{{TEMPLATE_VERSION}}": version,
        # {{PORT}}, {{VERSION_FILE}}는 초기 설정 태스크에서 에이전트가 채우므로 남겨 둔다
    }

    # 1. 생성할 파일 목록: dest 상대경로 -> src 상대경로
    plan = {rel: rel for rel in PLAIN}
    for dest_rel, by_scale in VARIANTS.items():
        plan[dest_rel] = by_scale[a.scale]
    if include_data:
        plan[DATA] = DATA
    if include_sitemap:
        if web_mobile:
            plan["docs/ui-design/SITE_MAP.web.md"] = SITE_MAP
            plan["docs/ui-design/SITE_MAP.mobile.md"] = SITE_MAP
        else:
            plan[SITE_MAP] = SITE_MAP

    # 2. 충돌 확인
    if not (a.force or a.in_place):
        conflicts = [rel for rel in plan if (a.dest / rel).exists()]
        if conflicts:
            sys.exit("이미 존재하는 파일이 있습니다 (--force로 덮어쓰기):\n  " + "\n  ".join(conflicts))

    # 3. 읽기 -> 가공 -> 쓰기
    written = []
    for dest_rel, src_rel in plan.items():
        text = (a.src / src_rel).read_text(encoding="utf-8")
        text = transform(dest_rel, text, a, include_data, include_sitemap, web_mobile)
        for k, v in subs.items():
            text = text.replace(k, v)
        out = a.dest / dest_rel
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text, encoding="utf-8")
        written.append(dest_rel)

    # 4. in-place 정리
    if a.in_place:
        shutil.rmtree(a.dest / "template", ignore_errors=True)
        shutil.rmtree(a.dest / "skills", ignore_errors=True)

    # 5. 요약
    print(f"생성 완료: {a.dest}")
    print(f"  Profile: scale={a.scale}, type={a.type}, server={a.server}, lang={a.lang}, template={version}")
    for rel in written:
        print(f"  + {rel}")
    skipped = [n for n, ok in (("DATA.md", include_data), ("SITE_MAP.md", include_sitemap)) if not ok]
    if skipped:
        print("  (제외: " + ", ".join(skipped) + ")")
    if a.scale != "small":
        print("  다음: develop 브랜치를 만들고 그곳에서 작업을 시작하세요.")
    print("  {{PORT}}와 {{VERSION_FILE}}는 초기 설정 태스크에서 에이전트가 채웁니다.")


def drop_lines(text: str, *prefixes: str) -> str:
    return "".join(line for line in text.splitlines(keepends=True)
                   if not any(line.startswith(p) for p in prefixes))


def replace_line(text: str, prefix: str, new_lines: list[str]) -> str:
    out = []
    for line in text.splitlines(keepends=True):
        if line.startswith(prefix):
            out.extend(l + "\n" for l in new_lines)
        else:
            out.append(line)
    return "".join(out)


def transform(dest_rel, text, a, include_data, include_sitemap, web_mobile):
    if dest_rel == "AGENTS.md":
        text = re.sub(r"<!-- Remove the rows.*?-->\n", "", text, flags=re.S)
        # Profile 값이 정해졌으니 선택지 주석은 지운다
        text = re.sub(r"^(- (?:Scale|Type|Server|Service language): \{\{[A-Z_]+\}\})\s+<!--.*?-->$",
                      r"\1", text, flags=re.M)
        if not include_data:
            text = drop_lines(text, f"| [{DATA}]")
        if not include_sitemap:
            text = drop_lines(text, f"| [{SITE_MAP}]")
        elif web_mobile:
            text = replace_line(text, f"| [{SITE_MAP}]", [
                "| [docs/ui-design/SITE_MAP.web.md](docs/ui-design/SITE_MAP.web.md) | Web screens, routes, flows | Before web UI work | Web screens or routes change |",
                "| [docs/ui-design/SITE_MAP.mobile.md](docs/ui-design/SITE_MAP.mobile.md) | Mobile screens, flows | Before mobile UI work | Mobile screens change |",
            ])

    elif dest_rel == "README.md":
        text = re.sub(r"<!-- Remove the rows.*?-->\n", "", text, flags=re.S)
        if not include_data:
            text = drop_lines(text, f"| [{DATA}]")
        if not include_sitemap:
            text = drop_lines(text, f"| [{SITE_MAP}]")
        elif web_mobile:
            text = replace_line(text, f"| [{SITE_MAP}]", [
                "| [docs/ui-design/SITE_MAP.web.md](docs/ui-design/SITE_MAP.web.md) | Web screens and flows |",
                "| [docs/ui-design/SITE_MAP.mobile.md](docs/ui-design/SITE_MAP.mobile.md) | Mobile screens and flows |",
            ])

    elif dest_rel == "TASK.md":
        text = re.sub(r"<!-- Profile에 없는 문서의 하위 작업은 삭제한다 -->\n", "", text)
        if not include_data:
            text = drop_lines(text, "  - [ ] DATA.md 작성")
        if not include_sitemap:
            text = drop_lines(text, "  - [ ] SITE_MAP.md 작성")
        elif web_mobile:
            text = replace_line(text, "  - [ ] SITE_MAP.md 작성",
                                ["  - [ ] SITE_MAP.web.md 작성", "  - [ ] SITE_MAP.mobile.md 작성"])

    elif dest_rel.startswith("docs/ui-design/SITE_MAP."):
        text = re.sub(r"<!-- Web \+ Mobile이면.*?-->\n", "", text, flags=re.S)
        if dest_rel.endswith(".web.md"):
            text = text.replace("# SITE_MAP\n", "# SITE_MAP (Web)\n", 1)
            text = re.sub(r"\bS-(\d\d)\b", r"W-\1", text)
            text = re.sub(r"\bS(\d\d)\b", r"W\1", text)
        elif dest_rel.endswith(".mobile.md"):
            text = text.replace("# SITE_MAP\n", "# SITE_MAP (Mobile)\n", 1)
            text = re.sub(r"\bS-(\d\d)\b", r"M-\1", text)
            text = re.sub(r"\bS(\d\d)\b", r"M\1", text)

    return text


if __name__ == "__main__":
    main()
