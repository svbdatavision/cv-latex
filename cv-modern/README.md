# cv-modern

Bilingual CV (EN + ES) with shared `layout.sty` / `preamble.tex` and **separate content per variant**.

| Dimension | Values |
|-----------|--------|
| `language` | `en`, `es` |
| `variant` | `short` (default/resumido), `expanded` (ampliado) |

Short and expanded content are independent directories. Editing `content/*/expanded/` cannot change the short CV.

## Layout

```text
content/
├── en/
│   ├── short/        # original EN CV content
│   ├── expanded/     # Expanded CV content
│   ├── 40-education.tex
│   ├── 50-languages.tex
│   └── 55-community.tex
└── es/
    ├── short/        # original ES CV content
    ├── expanded/     # CV Ampliado content
    ├── 40-education.tex
    ├── 50-languages.tex
    └── 55-community.tex
```

## Build

```bash
make              # short EN + ES (default; same as before)
make en           # short English
make es           # short Spanish
make expanded     # expanded EN + ES
make en-expanded  # Expanded CV (English)
make es-expanded  # CV ampliado (Spanish)
make everything   # all four PDFs
make check        # build everything + regression guard
make clean
make distclean
```

`make check` only needs Python. If `pdftotext` (poppler-utils) is installed it also validates PDF text; otherwise it validates the separated `.tex` sources.

## Outputs

| Language | Variant | Path |
|----------|---------|------|
| English | Short | `build/en/CV_von_Bergen_Sebastian.pdf` |
| Spanish | Short | `build/es/CV_von_Bergen_Sebastian_es.pdf` |
| English | Expanded | `build/en/CV_von_Bergen_Sebastian_expanded.pdf` |
| Spanish | Ampliado | `build/es/CV_von_Bergen_Sebastian_es_ampliado.pdf` |

Photo: `../images/CV_photo.png`.

## Workiva one-shot (EN only)

`build/` is gitignored, so Workiva PDFs are not in git. Generate them locally:

```bash
bash scripts/generate_workiva_en.sh
# → build/en/CV_von_Bergen_Sebastian_Workiva_AI_ML_Security.pdf
# → build/en/CV_von_Bergen_Sebastian_expanded_Workiva_AI_ML_Security.pdf
```

This does not modify permanent short/expanded sources. Requires `pdflatex` (TeX Live).
