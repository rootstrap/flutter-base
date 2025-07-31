#!/usr/bin/env python3
"""
full_coverage.py – Generates a single **lcov.info** for a multi-package Flutter
repository and uploads it to SonarQube.

Workflow
========
1. Read **sonar-project.properties** → use *exactly* the folders listed in
   `sonar.sources`.
2. Warn if there are libraries under `modules/*/lib` that are **not** declared
   in `sonar.sources` (they would be ignored by SonarQube otherwise).
3. Run tests *per module* (if a `test/` folder exists) and generate one LCOV
   report per module.
4. Normalise every `SF:` line so paths start with `app/lib/…` or
   `modules/<module>/lib/…` — this guarantees SonarQube can resolve them.
5. Merge all module reports and add **0 % coverage blocks** for every Dart file
   that still has no tests.
6. Validate paths before launching **sonar-scanner**.

Usage
-----
Interactive:
    python3 coverage/full_coverage.py

CI (no Y/N prompt):
    python3 coverage/full_coverage.py --ci

Dry-run (show commands, don’t execute):
    python3 coverage/full_coverage.py --dry-run
"""
from __future__ import annotations

import argparse
import configparser
import fnmatch
import getpass
import os
import re
import shutil
import subprocess
from pathlib import Path
from typing import Dict, List, Set

# Basic paths
PROJECT_ROOT     = Path.cwd()
COVERAGE_DIR     = PROJECT_ROOT / "coverage"
LCOV_MERGED_FILE = COVERAGE_DIR / "lcov.merged.info"
LCOV_FULL_FILE   = COVERAGE_DIR / "lcov.info"

# 1 · Read `sonar.sources`  →  build MODULE_PATHS
def load_sonar_sources(props: Path = PROJECT_ROOT / "sonar-project.properties") -> List[str]:
    """Return the comma/semicolon-separated folders configured in sonar.sources."""
    if not props.exists():
        return []
    # ConfigParser needs a header, so prepend a dummy section
    text = "[dummy]\n" + props.read_text(encoding="utf-8")
    cfg = configparser.ConfigParser()
    cfg.read_string(text)
    raw = cfg.get("dummy", "sonar.sources", fallback="")
    return [p.strip() for p in re.split(r"[;,]", raw) if p.strip()]

SONAR_SOURCES: List[str] = load_sonar_sources()

# Map friendly module name → lib path
MODULE_PATHS: Dict[str, Path] = {}
for src in SONAR_SOURCES:
    parts = src.split("/")
    if parts[0] == "app":
        MODULE_PATHS["app"] = PROJECT_ROOT / src
    elif parts[0] == "modules" and len(parts) >= 3:
        MODULE_PATHS[parts[1]] = PROJECT_ROOT / src

# 1.1 · Warn if there are libs not declared in sonar.sources
def warn_untracked_libs() -> None:
    detected: Set[str] = set()
    modules_dir = PROJECT_ROOT / "modules"
    if not modules_dir.exists():
        return

    for pkg in modules_dir.iterdir():
        if not pkg.is_dir():
            continue
        if (pkg / "lib").exists():
            detected.add(f"modules/{pkg.name}/lib")

    missing = detected - set(SONAR_SOURCES)
    if missing:
        print("\n⚠️  Libraries found in the repo but **not** listed in sonar.sources:")
        for m in sorted(missing):
            print(f"   • {m}")
        print("   ➜ Add them to sonar.sources if you want them analysed and covered,\n"
              "      otherwise they will be ignored by SonarQube.\n")

warn_untracked_libs()

# 2 · Ignore patterns and helper functions
IGNORE_PATTERNS = [
    "**/*.g.dart", "**/*.freezed.dart", "**/*.mocks.dart", "**/*.gr.dart",
    "**/*.gql.dart", "**/*.graphql.dart", "**/*.graphql.schema.*",
    "**/*.arb", "messages_*.dart", "lib/presenter/**", "**/generated/**",
]
IGNORED_CLASS_TYPES = ["abstract class", "mixin", "enum"]

def run(cmd: List[str], *, cwd: Path | None = None, dry: bool = False) -> None:
    """subprocess.run with an optional DRY-RUN mode."""
    if dry:
        print("DRY   $", " ".join(cmd))
        return
    subprocess.run(cmd, cwd=cwd, check=True)

# 3 · Test + coverage per module
def run_coverage_for_module(name: str, lib_path: Path, *, dry: bool = False) -> None:
    print(f"\n📦 Running coverage for module: {name}")
    module_dir, test_dir = lib_path.parent, lib_path.parent / "test"

    if not test_dir.exists():
        print(f"⚠️  '{name}' has no test directory → marked as 0 %")
        return

    run(["flutter", "test", "--coverage"], cwd=module_dir, dry=dry)

    src = module_dir / "coverage/lcov.info"
    dst = COVERAGE_DIR / f"lcov_{name}.info"
    if src.exists() and not dry:
        shutil.move(src, dst)
        print(f"✅ Coverage for {name} → {dst.relative_to(PROJECT_ROOT)}")

# 4 · Merge and normalise paths
def norm_path(module: str, original: str) -> str:
    """Convert `lib/foo.dart` → `app/lib/foo.dart` or `modules/<module>/lib/foo.dart`."""
    return f"app/{original}" if module == "app" else f"modules/{module}/{original}"

def merge_lcov_files(*, dry: bool = False) -> None:
    print("\n🔗 Merging module reports… (normalising SF: paths)")
    COVERAGE_DIR.mkdir(exist_ok=True)
    if dry:
        print("DRY   would merge individual LCOV files here")
        return

    with LCOV_MERGED_FILE.open("w", encoding="utf-8") as merged:
        for module in MODULE_PATHS:
            file = COVERAGE_DIR / f"lcov_{module}.info"
            if not file.exists():
                continue
            for line in file.read_text(encoding="utf-8").splitlines():
                if line.startswith("SF:"):
                    p = line[3:].strip()
                    if p.startswith("lib/"):
                        p = norm_path(module, p)
                    merged.write(f"SF:{p}\n")
                else:
                    merged.write(line + "\n")
    print(f"✅ Merged → {LCOV_MERGED_FILE.relative_to(PROJECT_ROOT)}")

# 5 · Add 0 % blocks for uncovered files
def ignore_file(path: Path) -> bool:
    rel = path.relative_to(PROJECT_ROOT).as_posix()
    return any(fnmatch.fnmatch(rel, pat) for pat in IGNORE_PATTERNS)

def ignore_entire_file(lines: List[str]) -> bool:
    if any("// coverage:ignore-file" in l for l in lines):
        return True
    return any(l.startswith(t) for t in IGNORED_CLASS_TYPES for l in lines)

def is_executable(line: str) -> bool:
    line = line.strip()
    if not line or line.startswith(("//", "/*", "*", "@", "import", "export", "part ")):
        return False
    if "override" in line:
        return False
    return True  # simplified: good enough for 0-coverage entries

def existing_covered() -> Set[Path]:
    covered: Set[Path] = set()
    if LCOV_MERGED_FILE.exists():
        for l in LCOV_MERGED_FILE.read_text(encoding="utf-8").splitlines():
            if l.startswith("SF:"):
                covered.add((PROJECT_ROOT / l[3:].strip()).resolve())
    return covered

def write_full_coverage() -> None:
    print("\n🧠 Writing final lcov.info (filling 0 % files)…")
    covered = existing_covered()
    all_files: Set[Path] = set()
    for src in MODULE_PATHS.values():
        all_files.update({f.resolve() for f in src.rglob("*.dart") if not ignore_file(f)})

    with LCOV_FULL_FILE.open("w", encoding="utf-8") as out:
        if LCOV_MERGED_FILE.exists():
            out.write(LCOV_MERGED_FILE.read_text(encoding="utf-8"))

        for f in sorted(all_files - covered):
            lines = f.read_text(encoding="utf-8").splitlines()
            if ignore_entire_file(lines):
                continue
            rel = f.relative_to(PROJECT_ROOT).as_posix()
            da = [f"DA:{i},0" for i, l in enumerate(lines, 1) if is_executable(l)]
            if da:
                entry = ["SF:" + rel, *da, f"LF:{len(da)}", "LH:0", "end_of_record"]
                out.write("\n".join(entry) + "\n")
    print(f"✅ Final lcov.info → {LCOV_FULL_FILE.relative_to(PROJECT_ROOT)}")

# 6 · Coverage summary
def coverage_summary() -> None:
    total = hits = 0
    for line in LCOV_FULL_FILE.read_text(encoding="utf-8").splitlines():
        if line.startswith("LF:"):
            total += int(line.split(":")[1])
        elif line.startswith("LH:"):
            hits += int(line.split(":")[1])
    pct = 0 if total == 0 else hits / total * 100
    print(f"\n📊 Global coverage: {hits}/{total} lines ({pct:.2f} %)")

# 7 · Validate paths before running sonar-scanner
def lcov_paths_valid() -> bool:
    for line in LCOV_FULL_FILE.read_text(encoding="utf-8").splitlines():
        if line.startswith("SF:"):
            p = line[3:].strip()
            if not any(p.startswith(src) for src in SONAR_SOURCES):
                print(f"⚠️  Path outside sonar.sources: {p}")
                return False
    return True

# MAIN
def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ci",      action="store_true", help="Non-interactive mode (always run sonar-scanner and fail on prompts)")
    parser.add_argument("--dry-run", action="store_true", help="Show what would happen without executing tests or sonar-scanner")
    args = parser.parse_args()

    # Clean previous coverage artefacts
    print("\n🧹 Cleaning coverage/")
    COVERAGE_DIR.mkdir(exist_ok=True)
    for f in COVERAGE_DIR.glob("lcov*.info"):
        f.unlink()

    # Generate coverage per module
    for name, lib in MODULE_PATHS.items():
        run_coverage_for_module(name, lib, dry=args.dry_run)

    merge_lcov_files(dry=args.dry_run)
    if not args.dry_run:
        write_full_coverage()
        coverage_summary()

    # SonarQube
    if not args.ci and input("\n🤖 Run sonar-scanner now? (y/n): ").lower() != "y":
        print("👋  Done without scanning.")
        return

    if not args.dry_run and not lcov_paths_valid():
        print("❌ Fix the paths before scanning.")
        return

    if not args.dry_run:
        token = os.environ.get("SONAR_TOKEN") or getpass.getpass("SONAR_TOKEN: ")
        os.environ["SONAR_TOKEN"] = token

    print("\n📡 Launching sonar-scanner…")
    run(["sonar-scanner"], dry=args.dry_run)

if __name__ == "__main__":
    main()
    