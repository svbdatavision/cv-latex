#!/usr/bin/env python3
"""Regression guard: four distinct short/expanded CV PDFs must coexist."""

from __future__ import annotations

import hashlib
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PDFS = {
    "en_short": ROOT / "build/en/CV_von_Bergen_Sebastian.pdf",
    "es_short": ROOT / "build/es/CV_von_Bergen_Sebastian_es.pdf",
    "en_expanded": ROOT / "build/en/CV_von_Bergen_Sebastian_expanded.pdf",
    "es_expanded": ROOT / "build/es/CV_von_Bergen_Sebastian_es_ampliado.pdf",
}

# Markers that belong only to the expanded variant.
EXPANDED_ONLY = (
    "Center of Excellence",
    "Brighterion",
    "Cybersource",
    "HDBSCAN",
    "Snowflake",
    "QUALIFY",
)

# Markers that should remain in short (original) skills/summary.
SHORT_MARKERS = {
    "en_short": ("FastAPI", "LangChain", "Azure ML"),
    "es_short": ("FastAPI", "LangChain", "Azure ML"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pdf_text(path: Path) -> str:
    return subprocess.check_output(
        ["pdftotext", "-layout", str(path), "-"],
        text=True,
        errors="replace",
    )


def main() -> int:
    missing = [k for k, p in PDFS.items() if not p.exists()]
    if missing:
        print(f"FAIL: missing PDFs: {missing}", file=sys.stderr)
        return 1

    hashes = {k: sha256(p) for k, p in PDFS.items()}
    if len(set(hashes.values())) != 4:
        print(f"FAIL: PDF hashes are not all distinct: {hashes}", file=sys.stderr)
        return 1

    names = [p.name for p in PDFS.values()]
    if len(set(names)) != 4:
        print(f"FAIL: PDF filenames collide: {names}", file=sys.stderr)
        return 1

    texts = {k: pdf_text(p) for k, p in PDFS.items()}

    for key, markers in SHORT_MARKERS.items():
        for marker in markers:
            if marker not in texts[key]:
                print(f"FAIL: short PDF {key} missing original marker {marker!r}", file=sys.stderr)
                return 1

    for key in ("en_short", "es_short"):
        for marker in EXPANDED_ONLY:
            if marker in texts[key]:
                print(
                    f"FAIL: short PDF {key} unexpectedly contains expanded marker {marker!r}",
                    file=sys.stderr,
                )
                return 1

    for key in ("en_expanded", "es_expanded"):
        hits = [m for m in EXPANDED_ONLY if m in texts[key]]
        if len(hits) < 3:
            print(
                f"FAIL: expanded PDF {key} looks too thin on expanded markers: {hits}",
                file=sys.stderr,
            )
            return 1

    # Content sources must remain separate on disk.
    short_exp = ROOT / "content/en/short/30-experience.tex"
    expanded_exp = ROOT / "content/en/expanded/30-experience.tex"
    if short_exp.read_text(encoding="utf-8") == expanded_exp.read_text(encoding="utf-8"):
        print("FAIL: short and expanded experience sources are identical", file=sys.stderr)
        return 1

    print("OK: four distinct short/expanded CV PDFs validated")
    for k, p in PDFS.items():
        print(f"  {k}: {p.relative_to(ROOT)} ({p.stat().st_size} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
