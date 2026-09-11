#!/usr/bin/env bash
# One-shot EN Workiva AI/ML Security CVs.
# Does NOT modify permanent short/expanded sources.
# Outputs:
#   build/en/CV_von_Bergen_Sebastian_Workiva_AI_ML_Security.pdf
#   build/en/CV_von_Bergen_Sebastian_expanded_Workiva_AI_ML_Security.pdf
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

ASSETS="$ROOT/scripts/workiva_en_assets"
TMP="$ROOT/_tmp_workiva"
MAIN_SHORT="$ROOT/_tmp_main.en.workiva.tex"
MAIN_EXP="$ROOT/_tmp_main.en.workiva.expanded.tex"
OUTDIR="$ROOT/build/en"
JOB_SHORT="CV_von_Bergen_Sebastian_Workiva_AI_ML_Security"
JOB_EXP="CV_von_Bergen_Sebastian_expanded_Workiva_AI_ML_Security"

TEX="${TEX:-pdflatex}"
TEXFLAGS="-interaction=nonstopmode -halt-on-error"

if ! command -v "$TEX" >/dev/null 2>&1; then
  echo "error: pdflatex not found. On Ubuntu/WSL install:" >&2
  echo "  sudo apt-get update && sudo apt-get install -y texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra" >&2
  exit 1
fi

if [[ ! -d "$ASSETS/short" || ! -d "$ASSETS/expanded" ]]; then
  echo "error: missing Workiva assets under scripts/workiva_en_assets/" >&2
  exit 1
fi

cleanup() {
  rm -rf "$TMP" "$MAIN_SHORT" "$MAIN_EXP"
  rm -f "$OUTDIR/${JOB_SHORT}".{aux,log,out} "$OUTDIR/${JOB_EXP}".{aux,log,out}
}
trap cleanup EXIT

rm -rf "$TMP"
mkdir -p "$TMP/short" "$TMP/expanded" "$OUTDIR"

# Headers: compact single-line role (matches prior Workiva EN PDFs).
cp content/en/expanded/00-header.tex "$TMP/short/00-header.tex"
cp content/en/expanded/00-header.tex "$TMP/expanded/00-header.tex"

cp "$ASSETS/short/"*.tex "$TMP/short/"
cp "$ASSETS/expanded/"*.tex "$TMP/expanded/"

# Safer hyphenation for long security terms (Prompt Injection, etc.).
cat > "$TMP/preamble.tex" <<'EOF'
\input{preamble}
\usepackage{lmodern}
\usepackage[T1]{fontenc}
\usepackage{needspace}
\newcommand{\cventrykeep}{\Needspace{9\baselineskip}}
\hyphenpenalty=10000
\exhyphenpenalty=10000
EOF

cat > "$MAIN_SHORT" <<'EOF'
\input{_tmp_workiva/preamble}

\begin{document}
\input{_tmp_workiva/short/00-header}
\input{_tmp_workiva/short/10-summary}
\input{_tmp_workiva/short/20-skills}
\input{_tmp_workiva/short/30-experience}
\input{content/en/40-education}
\input{content/en/50-languages}
\input{content/en/55-community}
\end{document}
EOF

cat > "$MAIN_EXP" <<'EOF'
\input{_tmp_workiva/preamble}

\begin{document}
\input{_tmp_workiva/expanded/00-header}
\input{_tmp_workiva/expanded/10-summary}
\input{_tmp_workiva/expanded/20-skills}
\input{_tmp_workiva/expanded/30-experience}
\input{content/en/40-education}
\input{content/en/50-languages}
\input{content/en/55-community}
\end{document}
EOF

echo "==> Building short Workiva EN PDF..."
"$TEX" $TEXFLAGS -output-directory="$OUTDIR" -jobname="$JOB_SHORT" "$MAIN_SHORT" >/tmp/workiva_short_build.log
"$TEX" $TEXFLAGS -output-directory="$OUTDIR" -jobname="$JOB_SHORT" "$MAIN_SHORT" >>/tmp/workiva_short_build.log

echo "==> Building expanded Workiva EN PDF..."
"$TEX" $TEXFLAGS -output-directory="$OUTDIR" -jobname="$JOB_EXP" "$MAIN_EXP" >/tmp/workiva_exp_build.log
"$TEX" $TEXFLAGS -output-directory="$OUTDIR" -jobname="$JOB_EXP" "$MAIN_EXP" >>/tmp/workiva_exp_build.log

# Sanity: permanent sources must still match git HEAD for Workiva keywords not belonging there.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git diff --quiet -- content/en/short content/en/expanded; then
    echo "==> Permanent EN content unchanged (ok)."
  else
    echo "warning: permanent EN content has local diffs (script did not write them)." >&2
  fi
fi

echo
echo "Created:"
ls -la "$OUTDIR/${JOB_SHORT}.pdf" "$OUTDIR/${JOB_EXP}.pdf"
echo
echo "Open folder (WSL):"
echo "  explorer.exe build/en"
