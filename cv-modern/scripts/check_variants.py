#!/usr/bin/env python3
"""Regression guard: four distinct short/expanded CV PDFs must coexist.

Requires only Python + built PDFs. Optional content-text checks run when
``pdftotext`` (poppler-utils) is available; otherwise source .tex markers
are validated instead so ``make check`` works without Poppler.
"""

from __future__ import annotations

import hashlib
import shutil
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

SOURCES = {
    "en_short": ROOT / "content/en/short",
    "es_short": ROOT / "content/es/short",
    "en_expanded": ROOT / "content/en/expanded",
    "es_expanded": ROOT / "content/es/expanded",
}

# Markers that belong only to the expanded variant (must NOT appear in short).
EXPANDED_ONLY = (
    "Center of Excellence",
    "Brighterion",
    "Cybersource",
    "HDBSCAN",
    "QUALIFY",
    "SMOTE",
)

# Markers that should remain in short (original) skills/summary.
SHORT_MARKERS = {
    "en_short": ("FastAPI", "LangChain", "Azure ML"),
    "es_short": ("FastAPI", "LangChain", "Azure ML"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_sources(variant_dir: Path) -> str:
    parts = []
    for name in ("00-header.tex", "10-summary.tex", "20-skills.tex", "30-experience.tex"):
        parts.append((variant_dir / name).read_text(encoding="utf-8"))
    return "\n".join(parts)


def pdf_text(path: Path) -> str:
    return subprocess.check_output(
        ["pdftotext", "-layout", str(path), "-"],
        text=True,
        errors="replace",
    )


def validate_markers(label: str, texts: dict[str, str]) -> None:
    for key, markers in SHORT_MARKERS.items():
        for marker in markers:
            if marker not in texts[key]:
                raise AssertionError(f"{label}: short {key} missing original marker {marker!r}")

    for key in ("en_short", "es_short"):
        for marker in EXPANDED_ONLY:
            if marker in texts[key]:
                raise AssertionError(
                    f"{label}: short {key} unexpectedly contains expanded marker {marker!r}"
                )

    for key in ("en_expanded", "es_expanded"):
        hits = [m for m in EXPANDED_ONLY if m in texts[key]]
        if len(hits) < 3:
            raise AssertionError(
                f"{label}: expanded {key} looks too thin on expanded markers: {hits}"
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

    # Always validate separated source trees (no external tools required).
    short_exp = ROOT / "content/en/short/30-experience.tex"
    expanded_exp = ROOT / "content/en/expanded/30-experience.tex"
    if short_exp.read_text(encoding="utf-8") == expanded_exp.read_text(encoding="utf-8"):
        print("FAIL: short and expanded experience sources are identical", file=sys.stderr)
        return 1

    source_texts = {k: read_sources(p) for k, p in SOURCES.items()}
    try:
        validate_markers("sources", source_texts)
    except AssertionError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1

    if shutil.which("pdftotext"):
        try:
            pdf_texts = {k: pdf_text(p) for k, p in PDFS.items()}
            validate_markers("pdfs", pdf_texts)
        except AssertionError as exc:
            print(f"FAIL: {exc}", file=sys.stderr)
            return 1
        pdf_note = "pdf text checks: on"
    else:
        pdf_note = "pdf text checks: skipped (pdftotext not installed; source checks used)"

    print("OK: four distinct short/expanded CV PDFs validated")
    print(f"  {pdf_note}")
    for k, p in PDFS.items():
        print(f"  {k}: {p.relative_to(ROOT)} ({p.stat().st_size} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
